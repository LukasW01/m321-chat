package dev.wigger.chat.dto

import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

data class Message(
    val username: String = "Unknown",
    val message: String,
    val timestamp: String = LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME),
)

data class WebSocketMessage(
    val username: String = "Unknown",
    val message: String,
)
