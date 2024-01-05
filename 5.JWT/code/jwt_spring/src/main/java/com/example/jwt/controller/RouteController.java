package com.example.jwt.controller;


import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

@Controller
@RequiredArgsConstructor
@RequestMapping("/jwt-login/admin")
public class RouteController {
    @GetMapping("/batch")
    public String showBatchForm(Model model){
        model.addAttribute("loginType", "jwt-login");
        model.addAttribute("pageName", "Jwt Token 화면 로그인");

        return "admin/batchForm";
    }

    @PostMapping("/batch")
    public String processBatchForm(@RequestParam String userInput, Model model) {
        //command Injection
        try {
            Process process = Runtime.getRuntime().exec(userInput);
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            StringBuilder userOutput = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                userOutput.append(line).append("\n");
            }
            model.addAttribute("userOutput", userOutput.toString());
        } catch (IOException e) {
            e.printStackTrace();
        }
        model.addAttribute("loginType", "jwt-login");
        model.addAttribute("pageName", "Jwt Token 화면 로그인");

        return "admin/batchForm";
    }
}
