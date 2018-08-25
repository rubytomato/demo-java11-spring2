package com.example.demo.condition;

import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

@Component
@Profile("dev & !app1 & !app2")
public class Develop implements AppCondition {
  @Override
  public String name() {
    return "dev";
  }
}
