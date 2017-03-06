# README

* This is my solution for a software that reads a public API.
* The chosen API is: http://dev.markitondemand.com/MODApis/Api/v2/
* However the Service wrote (FinancialAPI) is fully customizable, and could work with other APIs.

The software allows you to look up for a stock using symbol or any lookup value. Allows you to subscribe, and if the crontab is configured (using whenever --update-crontab) should automatically alert you if your stock goes above the current value in the next two hours.