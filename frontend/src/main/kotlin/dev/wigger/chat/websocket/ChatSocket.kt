package dev.wigger.chat.websocket

import dev.wigger.chat.dto.WebSocketMessage
import dev.wigger.chat.templates.Templates
import io.quarkus.websockets.next.OnClose
import io.quarkus.websockets.next.OnOpen
import io.quarkus.websockets.next.OnTextMessage
import io.quarkus.websockets.next.WebSocket
import io.quarkus.websockets.next.WebSocketConnection
import jakarta.enterprise.context.ApplicationScoped
import jakarta.inject.Inject

@WebSocket(path = "/gateway")
@ApplicationScoped
class ChatSocket {
    @Inject
    private lateinit var connection: WebSocketConnection
    
    @OnOpen(broadcast = true)
    fun onOpen(): String = Templates.message("User joined", " ").render()

    @OnClose
    fun onClose() {
        connection.broadcast().sendTextAndAwait(Templates.message("User left", " ").render())
    }

    @OnTextMessage(broadcast = true)
    fun onMessage(payload: WebSocketMessage): String = Templates.message(payload.message, payload.username).render()
}
