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
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

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
    public String list(Model model, @RequestParam(defaultValue = "1") int pageNo) {
        try {
            Pager pager = new Pager(userService.selectAllUsers().size(), pageNo);
            List<TUser> users = userService.selectWithPaging(pager);

            model.addAttribute("data", new Gson().toJson(users));
            model.addAttribute("pager", pager);
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("message", "데이터 조회에 실패했습니다.");
        }
        return "list";
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
