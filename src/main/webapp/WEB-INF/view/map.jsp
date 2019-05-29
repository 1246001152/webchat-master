<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<html>
<head>
    <title>WebChat | 聊天</title>
    <jsp:include page="include/commonfile.jsp"/>
</head>
<body>
<div class="am-cf admin-main">
    <ul class="am-list admin-sidebar-list">
        <li><a href="${ctx}/chat"><span class="am-icon-commenting"></span> 聊天</a></li>
    </ul>
    <div class="am-panel am-panel-default" >
        <div class="am-panel-hd">
            <h3 class="am-panel-title">用户在线列表 [<span id="onlinenum"></span>]</h3>
        </div>
        <ul class="am-list am-list-static am-list-striped" >
            <li class="am-active">${userid}</li>
        </ul>
        <ul class="am-list am-list-static am-list-striped" id="list">
        </ul>
    </div>
    <!-- 接收者 -->
    <div class="" style="float: left;display: none">
        <p class="am-kai">发送给 : <span id="sendto"></span></p>
    </div>
</div>
<script>
    
    // 去除重复两个数组中重复元素
    function array_diff(a, b) {
        for(var i=0;i<b.length;i++){
            for(var j=0;j<a.length;j++){
                if(a[j]==b[i]){
                    a.splice(j,1);
                    j=j-1;
                }
            }
        }
        return a;
    }
    /**
     * 解析后台传来的消息
     * "massage" : {
     *              "from" : "xxx",
     *              "to" : "xxx",
     *              "content" : "xxx",
     *              "time" : "xxxx.xx.xx"
     *          },
     * "type" : {notice|message},
     * "list" : {[xx],[xx],[xx]} 在线用户
     * "onlineCount" : 在线人数
     */
    function analysisMessage(message){
        message = JSON.parse(message);
        if(message.list != null && message.list != undefined){ //在线列表
            showOnline(message);
        }
    }

    /**
     * 展示在线列表
     */
    function showOnline(message){
        // 在线用户
        var list=message.list;
        // 获取所有用户
        var userList = '${userList}'.substring(1,'${userList}'.length-1).split(",");
        var users = array_diff(userList,list); // 去除在线用户

        $("#list").html("");    //清空在线列表
        $.each(list, function(index, item){     //添加私聊按钮
            var li = "<li>"+item+"</li>";
            if('${userid}' != item){    //排除自己
                // 提示信息条数
               var msgNum = window.localStorage.getItem(item)==null?"": window.localStorage.getItem(item);
                li = "<li  onclick=\"addChat('"+item+"');\"  >  "+item+" <span class=\"am-icon-phone\"><span>"+msgNum+"</li>";
                $("#list").append(li);
            }
        });
        // 不在线人数
        $.each(users, function(index, item){     //添加私聊按钮
            var li = "<li>"+item+"</li>";
            if('${userid}' != item.trim()){    //排除自己
                li = "<li  onclick=\"addChat('"+item+"');\"  >  "+item+"  </li>";
                $("#list").append(li);
            }
        });

        $("#onlinenum").text(message.onlineCount);     //获取在线人数
    }
    /**
     * 添加接收人
     */
    function addChat(user){
        window.localStorage.removeItem(user)
        var sendto = $("#sendto");
        sendto.text(user);
        $("#chat").show();
        $("#map").hide();
        location.href='${ctx}'+"/chat?user="+user;
    }

    //关闭浏览器直接断开websocket
    window.onbeforeunload = function(event) {
        ws.onclose =function(){};
        ws.close();
    }
</script>