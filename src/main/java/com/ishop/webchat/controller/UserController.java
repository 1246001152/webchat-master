package com.ishop.webchat.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.ModelAndView;

/**
 * NAME   :  WebChat/com.ishop.webchat.controller
 * Author :  Zhangjinfei
 * TODO   :  用户控制器
 */
@Controller
@SessionAttributes("userid")
public class UserController {

    /**
     * 聊天主页
     */
    @RequestMapping(value = "chat")
    public ModelAndView getIndex(String user){
        ModelAndView view = new ModelAndView("index");
        view.addObject("user",user);
        return view;
    }

    /**
     * 聊天地图
     */
    @RequestMapping(value = "map")
    public ModelAndView getMapUser(){
        ModelAndView view = new ModelAndView("map");
        return view;
    }
}
