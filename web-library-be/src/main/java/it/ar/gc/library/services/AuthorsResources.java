package it.ar.gc.library.services;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import javax.ws.rs.GET;
import javax.ws.rs.NotFoundException;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("/authors")
public class AuthorsResources {

  private final Map<String, Author> authors;

  /**
   *
   */
  public AuthorsResources() {
    this.authors = new HashMap<String, Author>();
    this.authors.put("12312",
      AuthorBuilder.author().withAge("23").withId("12312").withName("Massimo Guilizzoni")
      .withNickname("Peldi").build());
    this.authors.put("231232",
      AuthorBuilder.author().withAge("49").withId("231232").withName("Jurie Kravaciow")
      .withNickname("Jurie").build());
    this.authors.put("3312",
      AuthorBuilder.author().withAge("28").withId("3312").withName("Samule Guidoli")
      .withNickname("Samu28").build());
  }

  @GET()
  @Path("{id}")
  @Produces(MediaType.APPLICATION_JSON)
  public Author getAuthor(@PathParam("id") String id) {
    if (!this.authors.containsKey(id)) {
      throw new NotFoundException();
    }
    return this.authors.get(id);
  }

  @GET
  @Produces(MediaType.APPLICATION_JSON)
  public Collection<Author> getAuthors() {
    if (this.authors == null) {
      throw new NotFoundException();
    }
    return this.authors.values();
  }

}
