<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<html>
<head>
    <title>WebChat | 聊天</title>
    <jsp:include page="include/commonfile.jsp"/>
</head>
<body>
<div class="am-topbar admin-header">
    <div class="am-topbar-brand" >
        <i class="am-icon-weixin"></i> <strong>WebChat</strong> <small>网页聊天室</small>
    </div>
</div>
<div class="am-cf admin-main">
    <!-- sidebar start -->
        <ul class="am-list admin-sidebar-list">
            <li><a href="${ctx}/chat"><span class="am-icon-commenting"></span>${userid}与${user}的对话</a></li>
        </ul>
    <!-- sidebar end -->
    <!-- content start -->
    <div class="admin-content"  >
    <div class="">
            <!-- 聊天区 -->
            <div class="am-scrollable-vertical" id="chat-view" style="height: 510px;">
                <ul class="am-comments-list am-comments-list-flip" id="chat">
                </ul>
            </div>
            <!-- 输入区 -->
            <div class="am-form-group am-form">
                <textarea class="" id="message" name="message" rows="5"  placeholder="这里输入你想发送的信息..."></textarea>
            </div>
            <!-- 接收者 -->
            <div class="" style="float: left;display: none">
                <p class="am-kai">发送给 : <span id="sendto"></span></p>
            </div>
            <!-- 按钮区 -->
            <div class="am-btn-group am-btn-group-xs" style="float:right;">
                <button class="am-btn am-btn-default" type="button" onclick="clearConsole()"><span class="am-icon-trash-o"></span> 清屏</button>
                <button class="am-btn am-btn-default" type="button" onclick="sendMessage()"><span class="am-icon-commenting"></span> 发送</button>
            </div>
        </div>
    </div>
    <!-- content end -->
</div>
<script>
     // 获取用户留言
       var oldMsg2 = window.localStorage.getItem('${userid}' + "$" + '${user}');
       var oldMsg2Json = JSON.parse(oldMsg2);
       if(oldMsg2Json != null){
           for (var i = 0; i <oldMsg2Json.length ; i++) {
               var message = oldMsg2Json[i];
               var from =  message.from;
               var to =  message.to;
               var isSef = '${userid}' == from ? "am-comment-flip" : "";   //如果是自己则显示在右边,他人信息显示在左边
               if(from != '${userid}'){ // 发送人不是自己
                   if(from =='${user}'){
                       var html = "<li class=\"am-comment "+isSef+" am-comment-primary\"><a href=\"#link-to-user-home\"><img width=\"48\" height=\"48\" class=\"am-comment-avatar\" alt=\"\" src=\"${ctx}/"+message.from+"/head\"></a><div class=\"am-comment-main\">\n" +
                           "<header class=\"am-comment-hd\"><div class=\"am-comment-meta\">   <a class=\"am-comment-author\" href=\"#link-to-user\">"+message.from+"</a> :<time> "+message.time+"</time> "+to+"</div></header><div class=\"am-comment-bd\"> <p>"+message.content+"</p></div></div></li>";
                       $("#chat").append(html);
                   }
               }else{
                   var html = "<li class=\"am-comment "+isSef+" am-comment-primary\"><a href=\"#link-to-user-home\"><img width=\"48\" height=\"48\" class=\"am-comment-avatar\" alt=\"\" src=\"${ctx}/"+message.from+"/head\"></a><div class=\"am-comment-main\">\n" +
                       "<header class=\"am-comment-hd\"><div class=\"am-comment-meta\">   <a class=\"am-comment-author\" href=\"#link-to-user\">我说</a> :<time> "+message.time+"</time>"+to+" </div></header><div class=\"am-comment-bd\"> <p>"+message.content+"</p></div></div></li>";
                   $("#chat").append(html);
               }
           }
       }
    /**
     * 发送信息给后台
     */
    function sendMessage(){
        if(ws == null){
            layer.msg("连接未开启!", { offset: 0, shift: 6 });
            return;
        }
        // var message = $("#message").val();
        var message = editor.html();
        var to = $("#sendto").text();
        if(message == null || message == ""){
            layer.msg("请不要惜字如金!", { offset: 0, shift: 6 });
            return;
        }
        ws.send(JSON.stringify({
            message : {
                content : message,
                from : '${userid}',
                to : '${user}',      //接收人,如果没有则置空,如果有多个接收人则用,分隔
                time : getDateFull()
            },
            type : "message"
        }));
        editor.html("");
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
     * "list" : {[xx],[xx],[xx]}
     * "onlineCount" : 在线人数
     */
    function analysisMessage(message){
        message = JSON.parse(message);
        if(message.type == "message"){      //会话消息
            showChat(message.message);
        }
    }

    /**
     * 展示提示信息
     */
    function showNotice(notice){
      //  $("#chat").append("<div><p class=\"am-text-success\" style=\"text-align:center\"><span class=\"am-icon-bell\"></span> "+notice+"</p></div>");
        var chat = $("#chat-view");
        chat.scrollTop(chat[0].scrollHeight);   //让聊天区始终滚动到最下面
    }

    /**
     * 展示会话信息
     */
    function showChat(message){
        // 删除当前用户的提示
        window.localStorage.removeItem('${user}')
        var to = message.to;   //获取接收人
        var from = message.from;   //发送人

        // 将发送的信息写在localStorage 中
        var oldMsg = window.localStorage.getItem(to+ "$" +from);
        if (oldMsg == null) {  // 如果没有就创建一个数组
            oldMsg = [];
            oldMsg.push(message);
            window.localStorage.setItem(to + "$" + from, JSON.stringify(message))
        }else{  // 如果有就获取数组并再次存放
            var oldMsgJson = JSON.parse(oldMsg); // 获取历史信息
            if(oldMsgJson.length==undefined){ // 如果第一次获取则获取的是对象，所有准备一个数组
                var msgArr = [];
                msgArr.push(oldMsgJson)
                msgArr.push(message)
                window.localStorage.setItem(to + "$" + from, JSON.stringify(msgArr))
            }else{
                oldMsgJson.push(message);
                window.localStorage.setItem(to + "$" + from, JSON.stringify(oldMsgJson))
            }
        }

        var isSef = '${userid}' == message.from ? "am-comment-flip" : "";   //如果是自己则显示在右边,他人信息显示在左边
        if(from != '${userid}'){ // 发送人不是自己
            if(from =='${user}'){
                var html = "<li class=\"am-comment "+isSef+" am-comment-primary\"><a href=\"#link-to-user-home\"><img width=\"48\" height=\"48\" class=\"am-comment-avatar\" alt=\"\" src=\"${ctx}/"+message.from+"/head\"></a><div class=\"am-comment-main\">\n" +
                    "<header class=\"am-comment-hd\"><div class=\"am-comment-meta\">   <a class=\"am-comment-author\" href=\"#link-to-user\">"+message.from+"</a> :<time> "+message.time+"</time> "+to+"</div></header><div class=\"am-comment-bd\"> <p>"+message.content+"</p></div></div></li>";
                $("#chat").append(html);
            }else{
                var i = window.localStorage.getItem(from)==null? 0:window.localStorage.getItem(from);
                window.localStorage.setItem(from, ++i);
            }
        }else{
            var html = "<li class=\"am-comment "+isSef+" am-comment-primary\"><a href=\"#link-to-user-home\"><img width=\"48\" height=\"48\" class=\"am-comment-avatar\" alt=\"\" src=\"${ctx}/"+message.from+"/head\"></a><div class=\"am-comment-main\">\n" +
                "<header class=\"am-comment-hd\"><div class=\"am-comment-meta\">   <a class=\"am-comment-author\" href=\"#link-to-user\">我说</a> :<time> "+message.time+"</time>"+to+" </div></header><div class=\"am-comment-bd\"> <p>"+message.content+"</p></div></div></li>";
            $("#chat").append(html);
        }
        editor.html("");//清空输入区
        var chat = $("#chat-view");
        chat.scrollTop(chat[0].scrollHeight);   //让聊天区始终滚动到最下面
    }

    function appendZero(s){return ("00"+ s).substr((s+"").length);}  //补0函数

    function getDateFull(){
        var date = new Date();
        var currentdate = date.getFullYear() + "-" + appendZero(date.getMonth() + 1) + "-" + appendZero(date.getDate()) + " " + appendZero(date.getHours()) + ":" + appendZero(date.getMinutes()) + ":" + appendZero(date.getSeconds());
        return currentdate;
    }
    //关闭浏览器直接断开websocket
    window.onbeforeunload = function(event) {
        ws.onclose =function(){};
        ws.close();
    }
</script>
</body>
</html>
