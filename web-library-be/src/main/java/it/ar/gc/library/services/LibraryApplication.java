package it.ar.gc.library.services;

import java.util.HashSet;
import java.util.Set;

import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;

@ApplicationPath("/v1")
public class LibraryApplication extends Application {

  @Override
  public Set<Class<?>> getClasses() {
    final Set<Class<?>> returnValue = new HashSet<Class<?>>();
    returnValue.add(AuthorsResources.class);
    return returnValue;
  }
}
