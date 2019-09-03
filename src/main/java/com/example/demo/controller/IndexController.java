package com.example.demo.controller;

import com.example.demo.condition.AppCondition;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping(path = {"/", ""})
public class IndexController {
  private static Logger log = LogManager.getLogger(IndexController.class);

  private final Environment environment;
  private final AppCondition condition;

  public IndexController(Environment environment, AppCondition condition) {
    this.environment = environment;
    this.condition = condition;
  }

  @GetMapping
  public String index(Model model) {
    log.debug(() -> "index start");
    System.out.println(log.getClass().getCanonicalName());
    System.out.println("prop1:[" + System.getProperty("prop1") + "] prop2:[" + System.getProperty("prop2") + "]");
    System.out.println("prop3:[" + System.getProperty("prop3") + "] prop4:[" + System.getProperty("prop4") + "]");
    System.out.println("ENV1: [" + environment.getProperty("ENV1") + "] ENV2: [" + environment.getProperty("ENV2") + "]");
    System.out.println("condition:" + condition.name());
    model.addAttribute("message", "hello world");
    return "index";
  }

}
