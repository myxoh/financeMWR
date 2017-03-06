$(document).ready(function(){

	/* This is the handler for new quotes*/
	$('#quote').on('click', function(){
		loading();
		$.getJSON('finance/quote/'+$("#symbol").val()
			).done(function(data){
				$("#result_template").append("<div class='row'>");
				if(data){
					data.forEach(function(stock){
						add_result(stock.symbol, stock.price, stock.exchange, stock.name);
					});

				$("#result_template").append("</div>");
					$("#loading").hide();
				}else{
					no_results();
				}
			}
			).fail(function(){
				no_results();
			});
	});
	$("#query_results").on("click", ".subscribe_link", bind_results)
	$("#events").on("click", ".close_notification", close_notification)

	/*This is the automatic notifications loader*/
	setInterval(refresh, 10000) //Pulls notification every 10 seconds.
});

function refresh(){
	$.getJSON("notifications").done(function(notifications){
		notifications.forEach(function(notification){
				add_notification(notification.generated_by, notification.watching, notification.description);
		});
	}
	);
}

function add_notification(generated_by, watching, description){
	template = $("#notification_template");            //Load template
	template.find(".generated_by").text(generated_by);         //Update template
	template.find(".watching").text(watching); 
	template.find(".description").text(description); 
	$("#events").append(template.html());
	alert("New notification!")
}

function close_notification(evt){
	$(this).closest(".notification").remove();
	evt.preventDefault();

}

function bind_results(evt){
		$.post("/subscribe", "symbol="+$(this).data("symbol")+"&price="+$(this).data("price")
			).done(function(data){
				alert("Subscribed!");
				clear_results();
			}
			).fail(function(){alert("There was a problem subscribing you. Please try again")});
	evt.preventDefault();
}

function clear_results(){
	$("#query_results").html("");
}

function loading(){
	$("#query_results").html("<div id='loading'>Loading...</div>");
}

function no_results(){
	console.log("No results");
	template = $("#query_results").html("<div class=\"error\">Sorry, no results were found</div>");
}

function add_result(symbol, price, exchange, name){
	template = $("#result_template");            //Load template
	template.find(".price").text(price);         //Update template
	template.find(".symbol").text(symbol); 
	template.find(".exchange").text(exchange); 
	template.find(".name").text(name); 
	template.find(".subscribe_link").attr("data-symbol",symbol);
	template.find(".subscribe_link").attr("data-price",price);
	$("#query_results").append(template.html()); //Adds template 
}