package com.example.demo.controller;

import com.example.demo.service.TUserService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;

@Controller
public class HomeController {

    private final TUserService userService;

    public HomeController(TUserService userService) {
        this.userService = userService;
    }

    @GetMapping("/")
    public String home() {
        return "index";
    }

    @PostMapping("/user")
    public String postDBFile(MultipartFile file, RedirectAttributes redirectAttributes) {
        String fileName = file.getOriginalFilename();

        redirectAttributes.addAttribute("success", false);

        if (fileName != null && fileName.split("\\.")[1].equals("dbfile")) {
            try {
                userService.insertAllUsers(file);
                redirectAttributes.addAttribute("success", true);
            } catch (IOException ignored) {}
        }

        return "redirect:/";
    }
}
