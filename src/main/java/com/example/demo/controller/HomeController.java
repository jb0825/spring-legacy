package com.example.demo.controller;

import com.example.demo.vo.TUser;
import com.example.demo.service.TUserService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.util.List;
import java.util.Map;

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

    @ResponseBody
    @GetMapping("/user")
    public List<TUser> getUsers() {
        return userService.selectAllUsers();
    }

    @PostMapping("/user")
    public String postDBFile(MultipartFile file, RedirectAttributes redirect) {
        try {
            Map<Integer, String> map = userService.insertAllUsers(file);
            if (map != null) redirect.addFlashAttribute("data", map);

            redirect.addFlashAttribute("success", userService.getSuccess());
            redirect.addFlashAttribute("fail", userService.getFail());
        }
        catch (IOException e) { redirect.addFlashAttribute("message", "파일 업로드에 실패했습니다."); }
        catch (Exception e)   { redirect.addFlashAttribute("message", "dbfile 만 업로드 할 수 있습니다"); }

        return "redirect:/";
    }

}
