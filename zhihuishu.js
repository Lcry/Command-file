var fa=$("body");
        var btn=$("<li></li>");
        var json={
            "background":"#31e16d",
            "height":"16px",
            "padding":"5px",
            "cursor": "pointer",
            "top":"300px",
            "right":"80px",
            "position": "fixed"
        };
        btn.css(json);
        btn.html("<span id='lfsenior'>开启自动播放模式</span>");
        fa.append(btn);
        var bodywidth=$("#body").css("width");
        var mainwidth=$("#main").css("width");
        btn.click(function () {
           $("#lfsenior").html("自动模式已开启");
           //关闭弹题
            setInterval(function(){
                $(".popboxes_close").click();
                //获取当前进度
                var spans=$(".current_play span");
                var progress=spans[spans.size()-1].innerHTML;
                if("100"==progress.substring(progress.lastIndexOf("『")+1,progress.lastIndexOf("』")-1)){
                 //播放完毕
                   $(".next_lesson a").click();
                }else{
                   $("#vjs_mediaplayer_html5_api")[0].play();
                    $("#vjs_mediaplayer_html5_api")[0].muted=true;
                }
                 $("#lfsenior").html("自动模式已开启,本章进度:"+progress+"%");
            },100);
 
 
        });
