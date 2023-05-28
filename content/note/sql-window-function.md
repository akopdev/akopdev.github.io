---
title: "The power of SQL window functions"
tags: ["sql", "data analysis"]
---
Imagine a situation where you run a nationwide electronic store. You must determine how much each store contributes to the state’s sales.

```sql 
SELECT
 state,
 store_name,
 SUM(sales) AS total_sales,
 SUM(sales) / SUM(SUM(sales)) OVER (PARTITION BY state) AS sales_contribution
FROM
 store_sales
GROUP BY
 state,
 store_name
ORDER BY
 state,
 sales_contribution DESC;
 ```

The window function creates a window of records related to the current record and operates within the window. In this example, the window is the `state`.

## The basics of SQL window functions

Every window function has these two parts. We define the window following the `OVER` keyword. In this example, we only partition the dataset using the `state` column.
The operation will be performed among the records that share the same `state`.

Further, you can rearrange the widow records using the `ORDER BY` keyword. The following query uses it to get the rank of each store within its state.

```sql 
SELECT
 store_name,
 state,
 sales,
 DENSE_RANK() OVER (PARTITION BY state ORDER BY sales DESC) AS store_sales_rank
FROM
 store_sales;
```

In place of `DENSE_RANK`, you can use `RANK` or `ROW_NUMBER`.

`ROW_NUMBER` will assign a sequential number for tie and gives no importance to ties. `RANK` will assign the same rank for ties and skip the next one. 

For instance, if two stores have the same sales values, they both will get number 1. But number 2 will be skipped, and the next in line gets number 3. 
`DENSE_RANK` will also assign the same number to ties but won’t skip the next number. The next record will get the immediately following rank.

## Interesting ways we can use window functions

### Calculating running totals
Sum all the previous values to a certain point. For example, how much each store has sold since the beginning of the year by every month's end.

```sql 
SELECT
 store_name,
 MONTH,
 sales,
 SUM(sales) OVER (PARTITION BY store_name ORDER BY "month") AS running_total
FROM
 store_sales;
 ```

### Comparing to a group statistic
Compare each record to its group average. For instance, we may be interested in seeing each store's state averages.

```sql
SELECT
 store_name,
 state ,
 MONTH,
 sales,
 AVG(sales) OVER (PARTITION BY state, "month") AS running_total
FROM
 store_sales;
```

### Calculating moving averages
This query computes, for each store, the 3-point moving average.

```sql 
SELECT
 store_name ,
 MONTH,
 sales,
 AVG(sales) OVER (PARTITION BY store_name
ORDER BY
 MONTH ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_sales
FROM
 store_sales;
 ```

In addition to the usually appearing `PARTITION BY` and `ORDER BY` keywords, we use a few others. We tell SQL to consider only the 2 preceding and current records. 
By changing the parameter, you can even calculate different point moving averages.

Compute forward-facing moving averages.

```sql 
SELECT
 store_name ,
 MONTH,
 sales,
 AVG(sales) OVER (PARTITION BY store_name ORDER BY MONTH ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS moving_avg_sales
FROM
 store_sales;
 ```
