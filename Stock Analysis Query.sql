SELECT * FROM stocks.stock_data;


------------------------------- KPI 1 - Average Daily Trading Volume --------------------------------------------------------------------------------------------------------------------------------------        
SELECT  
    Ticker AS "Stock",  
    AVG(Volume) AS "Avg Daily Traded Volume"  
FROM stocks.stock_data  
GROUP BY Ticker  
ORDER BY AVG(Volume) DESC  
LIMIT 50000;
 
------------------------------- KPI 2 - Most Volatile Stocks  --------------------------------------------------------------------------------------------------------------------------------------- 
SELECT 
    Ticker As "Stock",
    round(avg(Beta),4) AS "avg of Beta values" 
FROM stocks.stock_data
GROUP BY Ticker
ORDER BY AVG(Beta) DESC
LIMIT 50000;
 
------------------------------ KPI 3 - Stocks with Highest Dividend and Lowest Dividend ------------------------------------------------------------------------------------------------------------------------------------------
SELECT Ticker AS "Stock",  
       SUM(`dividend amount`) AS "Dividend Amount"  
FROM stocks.stock_data  
GROUP BY Ticker  
ORDER BY AVG(`dividend amount`) DESC  
LIMIT 50000;


WITH DividendSummary AS (
    SELECT Ticker AS "Stock",  
           SUM(`dividend amount`) AS "Total Dividend"  
    FROM stocks.stock_data  
    GROUP BY Ticker
)
SELECT * FROM DividendSummary
WHERE `Total Dividend` = (SELECT MAX(`Total Dividend`) FROM DividendSummary) 
   OR `Total Dividend` = (SELECT MIN(`Total Dividend`) FROM DividendSummary);
   
------------------------------ KPI 4 - Highest and Lowest P/E Ratios  -----------------------------------------------------------------------------------------------------------------------------------   
(select Ticker as "Stock" , round(avg(`PE Ratio`),3) AS "Avg P/E Ratio" FROM stocks.stock_data 
group by Ticker
order by avg(`PE Ratio`)  DESC ); 

------------------------------ KPI 5 - Stocks with Highest Market Cap --------------------------------------------------------------------------------------------------------------------------------

(select Ticker as "Stock" ,CONCAT((ROUND((avg(`Market Cap`)/100000000),1))," B") AS "Avg Market Capital" 
 FROM stocks.stock_data 
 group by Ticker 
 order by avg(`Market Cap`)  DESC) ;

---------------------------- KPI 6 - Stocks Near 52 Week High -------------------------------------------------------------------------------------------------------------------------------------

(select Ticker as "Stock" ,round(avg(`Adjusted Close`),4)  AS "Avg Stock Price" ,
	max(`52 Week High`) as "52 Week High" ,round((max(`52 Week High`)-avg(`Adjusted Close`)),4) as "Difference"
FROM stocks.stock_data
	group by Ticker 
		order by Ticker  DESC);

---------------------------- KPI 7 - Stocks Near 52 Week Low -------------------------------------------------------------------------------------------------------------------------------------------- Ticker as "Stock" ,round(avg(adjusted_close),2)  AS "Avg Stock Price" ,

(select Ticker as "Stock" ,round(avg(`Adjusted Close`),2)  AS "Avg Stock Price" ,
	min(`52 Week Low`) as "52 Week Low" ,round(-(min(`52 Week Low`)-avg(`Adjusted Close`)),2) as "Difference"
FROM stocks.stock_data
	group by ticker 
		order by ticker  DESC);
--------------------------- KPI 8 - Stocks with Strong Buy Signals and stocks with Strong Selling Signal -----------------------------------------------------------------------------------------------------------------------------------------
 
SELECT 
    TICKER, 
    date, 
    `RSI (14 days)` AS "RSI (14 days)", 
    MACD,  
    (CASE   
        WHEN `RSI (14 days)` <= 45 AND MACD > 0 THEN "BUY"  
        WHEN `RSI (14 days)` >= 69 AND MACD < 0 THEN "SELL"  
        ELSE "NEUTRAL"  
    END) AS "Buy/Neutral/Sell"   
FROM stocks.stock_data  
LIMIT 50000;