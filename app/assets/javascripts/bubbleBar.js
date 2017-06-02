(function() {
    var paper, circs, txtCircs, i, nowX, nowY, timer, props = {}, toggler = 0, elie, dx, dy, rad, cur, opa;
    var bbarTerms = [
        "Colors","Landscapes","Animal","Architecture","People","Machines"
        ];
        
    var bbSubTerms = [
        ["Black","White","Red","Orange","Yellow","Green","Blue","Purple","Grey","Tan"],
        ["Coastline","Desert","Forest","Mountain","Urban","Plain","Cave","River","Waterfall","Horizon","Winter","Ice","Meadow"],
        ["Tiger","Panther","Cat","Bird","Cow","Otter","Dog","Bug","Lobster","Fish","Alligator"]
        ];
    

    // Returns a random integer between min and max  
    // Using Math.round() will give you a non-uniform distribution!  
    function ran(min, max)  
    {  
        return Math.floor(Math.random() * (max - min + 1)) + min;  
    } 
    
    function moveIt()
    {
        if ($('.bubbleBar').length) {
            var bbWidth = $('.bubbleBar').outerWidth();
            var bbHeight = $('.bubbleBar').outerHeight();
            bbWidth = parseInt(bbWidth);
            bbHeight = parseInt(bbHeight);

            for(i = 0; i < txtCircs.length; ++i)
            {            
                  // Reset when time is at zero
                if (! circs[i].time) 
                {
                    circs[i].time  = ran(30, 100);
                    circs[i].deg   = ran(-179, 180);
                    circs[i].vel   = ran(1, 5);  
                    circs[i].curve = ran(0, 1);
                    circs[i].fade  = ran(0, 1);
                    circs[i].grow  = ran(-2, 2); 
                }                

                moving = circs[i].data("moving");

                if (moving) {
                        // Get position
                    nowX = circs[i].attr("cx");
                    nowY = circs[i].attr("cy");

                       // Calc movement
                    dx = circs[i].vel * Math.cos(circs[i].deg * Math.PI/180);
                    dy = circs[i].vel * Math.sin(circs[i].deg * Math.PI/180);
                        // Calc new position
                    nowX += dx;
                    nowY += dy;
                        // Calc wrap around
                    if (nowX < 0) nowX = bbWidth + nowX;
                    else          nowX = nowX % bbWidth;            
                    if (nowY < 0) nowY = bbHeight + nowY;
                    else          nowY = nowY % bbHeight;
                    
                    // Render moved particle
                    // there is a bug that causes nowX and nowY to be NaN, until 
                    // we figure out why, just do nothing if that case occurs.

                    if (!isNaN(nowX) && !isNaN(nowY)) {
                        // txtCircs[i].animate({cx: nowX, cy: nowY});
                        circs[i].attr({cx: nowX, cy: nowY});
                        labels[i].attr({x: nowX, y: nowY})
                    }
                }
                
                    // Calc growth
                // rad = circs[i].attr("r");
                // if (circs[i].grow > 0) circs[i].attr("r", Math.min(30, rad +  .1));
                // else                   circs[i].attr("r", Math.max(10,  rad -  .1));
                
                //     // Calc curve
                // if (circs[i].curve > 0) circs[i].deg = circs[i].deg + 2;
                // else                    circs[i].deg = circs[i].deg - 2;
                
                //     // Calc opacity
                // opa = circs[i].attr("fill-opacity");
                // if (circs[i].fade > 0) {
                //     circs[i].attr("fill-opacity", Math.max(.3, opa -  .01));
                //     circs[i].attr("stroke-opacity", Math.max(.3, opa -  .01)); }
                // else {
                //     circs[i].attr("fill-opacity", Math.min(1, opa +  .01));
                //     circs[i].attr("stroke-opacity", Math.min(1, opa +  .01)); }

                // Progress timer for particle
                circs[i].time = circs[i].time - 1;
                
                    // Calc damping
                if (circs[i].vel < 1) circs[i].time = 0;
                else circs[i].vel = circs[i].vel - .05;              
           
            } 
            timer = setTimeout(moveIt, 60);
        }
    }
    
    window.onload = function () {

        // check for existence of element .bubbleBar
        //
        if ($('.bubbleBar').length) {
            // get width and height of bubblebar:
            //
            var bbWidth = $('.bubbleBar').outerWidth();
            var bbHeight = $('.bubbleBar').outerHeight();
            bbWidth = parseInt(bbWidth);
            bbHeight = parseInt(bbHeight);
          
            paper = Raphael("bubbles", bbWidth, bbHeight);
            circs = paper.set();
            labels = paper.set();
            txtCircs = paper.set();

            for (i = 0; i < bbSubTerms[1].length; ++i)
            {

                // create label for our search term
                //
                label = bbSubTerms[1][i];
                var text = paper.text(x,y,label).attr({
                    fill: 'white',
                    "font-size":16, 
                    "font-family": "Arial, Helvetica, sans-serif" 
                });

                // create a circle large enough to fit the keyword
                //
                var radius = (text.getBBox().width + 6) / 2;
                opa = ran(3,10)/10;
                var x = ran(0,bbWidth);
                var y = ran(0,bbHeight)
                var circle = paper.circle(x,y,radius).attr({
                    "fill-opacity": opa,
                    "stroke-opacity": opa
                });

                // bring label to visibility from behind circle
                text.toFront();

                // set custom attributes for motion
                //
                circle.data('moving', true);
                circle.data('label', label);

                // freeze and highlight bubble on mouseover, restore motion and visual after
                //
                circle.hover(function () {
                    this.data('moving', false);
                    this.attr("stroke", "white");
                    this.attr("stroke-width", 3);
                }, function () {
                    this.data('moving', true);
                    this.attr("stroke", "#00DDAA");
                    this.attr("stroke-width", 1);
                });

                // add a search function
                circle.click(function (e) {
                    var csrch = this.data('label');
                    // alert('clicked ' + csrch);
                    e.preventDefault();
                    $.ajax({
                        type: "GET",
                        url: "/?srchterm=" + csrch,
                        // data: $.param({ srchterm: csrch} ),
                        dataType: "html",
                        success: function(response, status, request){
                            $('body').html(response);
                            // alert("request: " + request);
                            // alert("search with " + csrch);
                            // window.location.replace("/pictures?srchterm:" + csrch);
                            // window.location.replace(stat);
                        },
                        error: function(XMLHttpRequest, textStatus, errorThrown) {
                            alert("--- error: " + errorThrown);
                        }
                    });
                });

                text.click(function(e){
                    var tsrch = this.attr('text');
                    // alert('text click ' + tsrch);
                    e.preventDefault();
                    $.ajax({
                        type: "GET",
                        url: "/bubbleBar",
                        data: $.param({ srchterm: tsrch} ),
                        success: function(){
                            alert("search with " + tsrch);
                            // window.location.replace("/pictures");
                        },
                        error: function(XMLHttpRequest, textStatus, errorThrown) {
                            alert("--- error: " + errorThrown);
                        }
                    });
                });

                circs.push(circle);
                labels.push(text);

                // create a unified set with the circle and the text
                var txtCirc = paper.set();
                txtCirc.push(circle,text);

                txtCircs.push(txtCirc);

            }
            circs.attr({fill: "#00DDAA", stroke: "#00DDAA"});
            moveIt();
        //     elie = document.getElementById("toggle");
        //     elie.onclick = function() {
        //         (toggler++ % 2) ? (function(){
        //                 moveIt();
        //                 elie.value = " Stop ";
        //             }()) : (function(){
        //                 clearTimeout(timer);
        //                 elie.value = " Start ";
        //             }());
        //     }
        }
    };
}());