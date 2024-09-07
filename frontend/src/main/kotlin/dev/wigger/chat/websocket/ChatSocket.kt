package dev.wigger.chat.websocket

import dev.wigger.chat.dto.Message
import dev.wigger.chat.dto.WebSocketMessage
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
    
    @OnOpen(broadcast = true)
    fun onOpen(): String {
        return Templates.message("User joined", " ").render()
    }

    @OnClose
    fun onClose() {
        connection.broadcast().sendTextAndAwait(Templates.message("User left", " ").render())
    }

    @OnTextMessage(broadcast = true)
    fun onMessage(w: WebSocketMessage): String {
        return Templates.message(w.message, w.username).render()
    }
}