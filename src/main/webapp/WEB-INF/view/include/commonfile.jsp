<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<link rel="stylesheet" href="${ctx}/static/plugins/amaze/css/amazeui.min.css">
<link rel="stylesheet" href="${ctx}/static/plugins/amaze/css/admin.css">
<link rel="stylesheet" href="${ctx}/static/plugins/contextjs/css/context.standalone.css">
<script src="${ctx}/static/plugins/jquery/jquery-2.1.4.min.js"></script>
<script src="${ctx}/static/plugins/amaze/js/amazeui.min.js"></script>
<script src="${ctx}/static/plugins/amaze/js/app.js"></script>
<script src="${ctx}/static/plugins/layer/layer.js"></script>
<script src="${ctx}/static/plugins/laypage/laypage.js"></script>
<script src="${ctx}/static/plugins/contextjs/js/context.js"></script>

<script charset="utf-8" src="${ctx}/static/kindeditor/kindeditor-all.js"></script>
<script charset="utf-8" src="${ctx}/static/kindeditor/lang/zh-CN.js"></script>
<script src="${ctx}/static/plugins/sockjs/sockjs.js"></script>
<script>
    var path = '${ctx}';
    KindEditor.ready(function(K) {
         window.editor = K.create('#message');
    });
    var wsServer = null;
    var ws = null;
    wsServer = "ws://" + location.host+"${pageContext.request.contextPath}" + "/chatServer";
    ws = new WebSocket(wsServer); //创建WebSocket对象
    ws.onopen = function (evt) {
        // layer.msg("已经建立连接", { offset: 0}); //全局连接提示
    };
    ws.onmessage = function (evt) {
        analysisMessage(evt.data);  //解析后台传回的消息,并予以展示
    };
    ws.onerror = function (evt) {
        // layer.msg("连接异常", { offset: 0});
        console.log("连接异常")
    };
    ws.onclose = function (evt) {
        // layer.msg("已经关闭连接", { offset: 0});
        console.log("已经关闭连接")
    };
</script>