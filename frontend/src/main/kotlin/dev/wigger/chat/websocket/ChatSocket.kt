package dev.wigger.chat.websocket

import com.beust.klaxon.Klaxon
import dev.wigger.chat.dto.Message
import dev.wigger.chat.templates.Templates
import io.quarkus.websockets.next.OnClose
import io.quarkus.websockets.next.OnOpen
import io.quarkus.websockets.next.WebSocket
import io.quarkus.websockets.next.WebSocketConnection
import io.quarkus.websockets.next.OnTextMessage
import jakarta.enterprise.context.ApplicationScoped
import jakarta.inject.Inject


@WebSocket(path = "/gateway")
@ApplicationScoped
class ChatSocket {
    @Inject
    private lateinit var connection: WebSocketConnection

    enum class MessageType { USER_JOINED, USER_LEFT }

    @JvmRecord
    data class ChatMessage(val type: MessageType, val message: String?)
    
    @OnOpen(broadcast = true)
    fun onOpen(): ChatMessage {
        return ChatMessage(MessageType.USER_JOINED, null)
    }

    @OnClose
    fun onClose() {
        connection.broadcast().sendTextAndAwait(ChatMessage(MessageType.USER_LEFT, null))
    }

    @OnTextMessage(broadcast = true)
    fun onMessage(m: String): String {
        val json = Klaxon().parse<Message>(m)!!
        
        return Templates.message(json.message, json.username).render()
    }
}