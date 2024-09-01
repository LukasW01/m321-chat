package dev.wigger.chat.templates

import io.quarkus.qute.CheckedTemplate
import io.quarkus.qute.TemplateInstance
import java.time.format.DateTimeFormatter
import java.time.LocalDateTime

@CheckedTemplate
object Templates {
    @JvmStatic
    external fun index(): TemplateInstance

    @JvmStatic
    external fun message(
        message: String,
        username: String,
        timestamp: String = LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_TIME)
    ): TemplateInstance
}