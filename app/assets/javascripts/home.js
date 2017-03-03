$(document).ready(function(){
	$('#quote').on('click', function(){
		clear_results();
		$.getJSON('finance/quote/'+$("#symbol").val()
			).done(function(data){
				console.log(data);
				if(data){
					data.forEach(function(stock){
						add_result(stock.symbol, stock.price, stock.exchange, stock.name);
					})
				}else{
					no_results();
				}
			}
			).fail(function(){
				no_results();
			});
	});

});


function clear_results(){
	template = $("#query_results").html("Loading...");
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
	$("#query_results").append(template.html()); //Adds template 
}