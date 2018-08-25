package com.example.demo.condition;

import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

@Component
@Profile("dev & app1")
public class DevApp1 implements AppCondition {

  @Override
  public String name() {
    return "app1";
  }

}
