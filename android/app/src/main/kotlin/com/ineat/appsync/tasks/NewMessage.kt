package com.ineat.appsync.tasks

import com.amazonaws.mobileconnectors.appsync.AWSAppSyncClient
import com.apollographql.apollo.GraphQLCall
import com.apollographql.apollo.api.Response
import com.apollographql.apollo.exception.ApolloException
import com.google.gson.Gson
import com.ineat.appsync.NewMessageMutation
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class NewMessage(private val client: AWSAppSyncClient, private val call: MethodCall, private val result: MethodChannel.Result) {

    operator fun invoke() {
        val content = call.argument<String>("content")
        val sender = call.argument<String>("sender")

        val mutation = NewMessageMutation.builder()
                .content(content)
                .sender(sender)
                .build()

        client.mutate(mutation).enqueue(object : GraphQLCall.Callback<NewMessageMutation.Data>() {


            override fun onResponse(response: Response<NewMessageMutation.Data>) {
                parseResponse(response)
            }

            override fun onFailure(e: ApolloException) {
                result.error("onFailure", e.message, null)
            }

        })
    }

    private fun parseResponse(response: Response<NewMessageMutation.Data>) {
        if (response.hasErrors().not()) {
            val newMessage = response.data()?.newMessage()?.let {
                return@let mapOf(
                        "id" to it.id(),
                        "content" to it.sender(),
                        "sender" to it.sender()
                )
            }

            newMessage?.let {
                val json = Gson().toJson(newMessage)
                result.success(json)
            } ?: run {
                result.success(null)
            }
        } else {
            val error = response.errors().map { it.message() }.joinToString(", ")
            result.error("Errors", error, null)
        }
    }

}