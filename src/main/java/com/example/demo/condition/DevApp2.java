package com.example.demo.condition;

import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

@Component
@Profile("dev & app2")
public class DevApp2 implements AppCondition {
  @Override
  public String name() {
    return "app2";
  }
}
