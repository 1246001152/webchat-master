package com.ishop.webchat.controller;

import com.ishop.webchat.utils.WordDefined;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

/**
 * Author :  Zhangjinfei
 * TODO   :  用户登录与注销
 */
@Controller
@RequestMapping(value = "/user")
public class LoginController {



    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String login() {
        return "login";
    }

    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public String login(String userid, HttpSession session, RedirectAttributes attributes, HttpServletRequest request ,
                        WordDefined defined) {
        if (!getUsers().contains(userid)) {
            attributes.addFlashAttribute("error", defined.LOGIN_USERID_ERROR);
            return "redirect:/user/login";
        } else {
            session.setAttribute("userid", userid);
            session.setAttribute("login_status", true);
            attributes.addFlashAttribute("message", defined.LOGIN_SUCCESS);
            session.setAttribute("userList",  getUsers());
            return "redirect:/map";
        }
    }
    @RequestMapping(value = "/getUsers")
    public List<String> getUsers(){
        List<String> list = new ArrayList<>();
        list.add("aaa");
        list.add("bbb");
        list.add("ccc");
        list.add("admin");
        list.add("aaa111");
        list.add("aaa222");
        return list;
    }
}
