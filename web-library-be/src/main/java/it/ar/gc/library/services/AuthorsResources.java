package it.ar.gc.library.services;

import java.util.HashSet;
import java.util.Set;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("/authors")
public class AuthorsResources {

  private final Set<Author> authors;

  /**
   *
   */
  public AuthorsResources() {
    this.authors = new HashSet<Author>();
    this.authors.add(AuthorBuilder.author().withAge("23").withId("12312")
        .withName("Massimo Guilizzoni").withNickname("Peldi").build());
    this.authors.add(AuthorBuilder.author().withAge("49").withId("231232")
      .withName("Jurie Kravaciow").withNickname("Jurie").build());
    this.authors.add(AuthorBuilder.author().withAge("28").withId("3312").withName("Samule Guidoli")
        .withNickname("Samu28").build());
  }

  @GET
  @Produces(MediaType.APPLICATION_JSON)
  public Set<Author> getAuthors() {
    return this.authors;
  }

}
