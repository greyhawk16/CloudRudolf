package com.example.jwt.controllerAdivce;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import javax.servlet.http.HttpServletRequest;

@ControllerAdvice
public class LoginControllerAdvice {

    @ModelAttribute
    public void addModel(Model model, HttpServletRequest request) {
        String requestUri = request.getRequestURI();

        if (requestUri.contains("api")) {
            return;
        }

        if(requestUri.contains("jwt-login")) {
            model.addAttribute("loginType", "jwt-login");
            model.addAttribute("pageName", "Jwt Token 화면 로그인");
        }
    }
}