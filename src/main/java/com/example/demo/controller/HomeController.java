package com.example.demo.controller;

import com.example.demo.dto.FailInfo;
import com.example.demo.exception.FileEmptyException;
import com.example.demo.exception.FileExtException;
import com.example.demo.util.Pager;
import com.example.demo.vo.TUser;
import com.example.demo.service.TUserService;
import com.google.gson.Gson;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
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
        String message = null;

        try {
            FailInfo data = userService.insertAllUsers(file);
            if (data.getList().size() > 0) data.listToJSON();
            redirect.addFlashAttribute("info", data);
        }
        catch (FileEmptyException | FileExtException e) { message = e.getMessage(); }
        catch (Exception e) { message = "파일 업로드에 실패했습니다."; }

        redirect.addFlashAttribute("message", message);
        return "redirect:/";
    }

    @GetMapping("/list")
    public String test() { return "list"; }

    @ResponseBody
    @GetMapping("/user/page/{pageNo}")
    public Object getUsersWithPaging(@PathVariable int pageNo) {
        Pager pager = userService.setPager(pageNo);
        List<TUser> users = userService.selectWithPaging(pager);
        Map<String, Object> data = new HashMap<>();
        data.put("users", users);
        data.put("pager", pager);

        return new Gson().toJson(data);
    }

    @GetMapping("/list/dhtmlx")
    public String listDhtmlxPagination(Model model) {
        try {
            model.addAttribute("data", new Gson().toJson(userService.selectAllUsers()));
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("message", "데이터 조회에 실패했습니다.");
        }

        return  "list-dhtmlx";
    }
}
