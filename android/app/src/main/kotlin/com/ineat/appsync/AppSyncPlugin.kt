package com.ineat.appsync

import com.amazonaws.mobileconnectors.appsync.AWSAppSyncClient
import com.amazonaws.mobileconnectors.appsync.sigv4.BasicAPIKeyAuthProvider
import com.amazonaws.regions.Regions
import com.ineat.appsync.tasks.GetAllMessages
import com.ineat.appsync.tasks.NewMessage
import com.ineat.appsync.tasks.SubscriptionToNewMessage
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

/**
 * Plugin to call GraphQL requests generated from the schema
 */
class AppSyncPlugin private constructor(private val registrar: PluginRegistry.Registrar, private val channel: MethodChannel) : MethodChannel.MethodCallHandler {

    companion object {
        const val CHANNEL_NAME = "com.ineat.appsync"
        const val QUERY_GET_ALL_MESSAGES = "getAllMessages"
        const val MUTATION_NEW_MESSAGE = "newMessage"
        const val SUBSCRIBE_NEW_MESSAGE = "subscribeNewMessage"
        const val SUBSCRIBE_NEW_MESSAGE_RESULT = "subscribeNewMessageResult"

        fun registerWith(registrar: PluginRegistry.Registrar) {
            val channel = MethodChannel(registrar.messenger(), CHANNEL_NAME)
            val instance = AppSyncPlugin(registrar, channel)
            channel.setMethodCallHandler(instance)
        }
    }

    /**
     * Client AWS AppSync for call GraphQL requests
     */
    var client: AWSAppSyncClient? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        prepareClient(call)
        onPerformMethodCall(call, result)
    }

    /**
     * Handle type method. Call task for run GraphQL request
     */
    private fun onPerformMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            QUERY_GET_ALL_MESSAGES -> GetAllMessages(client!!, call, result)()
            MUTATION_NEW_MESSAGE -> NewMessage(client!!, call, result)()
            SUBSCRIBE_NEW_MESSAGE -> SubscriptionToNewMessage(client!!, call, channel)()
            else -> result.notImplemented()
        }
    }

    /**
     * Create AWS AppSync Client if not exist
     */
    private fun prepareClient(call: MethodCall) {
        val endpoint = call.argument<String>("endpoint")
        val apiKey = call.argument<String>("apiKey")
        
        if (client == null) {
            client = AWSAppSyncClient.builder()
                    .context(registrar.context().applicationContext)
                    .apiKey(BasicAPIKeyAuthProvider(apiKey))
                    .region(Regions.EU_CENTRAL_1)
                    .serverUrl(endpoint)
                    .build()
        }
    }

}