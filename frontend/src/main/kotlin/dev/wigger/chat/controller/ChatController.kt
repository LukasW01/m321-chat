package dev.wigger.chat.controller

import dev.wigger.chat.templates.Templates
import jakarta.enterprise.context.ApplicationScoped
import jakarta.ws.rs.Consumes
import jakarta.ws.rs.GET
import jakarta.ws.rs.Path
import jakarta.ws.rs.Produces
import jakarta.ws.rs.core.MediaType

@ApplicationScoped
@Path("/")
class ChatController {
    @GET
    @Produces(MediaType.TEXT_HTML) @Consumes(MediaType.TEXT_PLAIN)
    fun index(): String = Templates.index().render()
}
