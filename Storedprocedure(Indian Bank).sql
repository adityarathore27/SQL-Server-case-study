select @@SERVERname
  

  use ibank
  go


create proc usp_previousmonthbankstatement  
(  
   @acid int
)  
as  
begin  
            declare @custname varchar(40)  
   declare @pid char(2)  
   declare @brid char(3)  
   declare @balance money  
  
   declare @rno int  
   declare @dot datetime  
      declare @txntype char(3)  
   declare @chqno int  
   declare @txnamt money  

   declare @lastmonth varchar(40) 
   declare @todaysdate datetime
   set @todaysdate=getdate()

   --get the last month name
   select @lastmonth=datename(mm,dateadd(mm,-1,@todaysdate))

   ----get first 3 letters from the month name
   declare @lastmonth_short varchar(3)
   select @lastmonth_short=substring (@lastmonth,1,3)
   --print @lastmonth_short
   --print @lastmonth

   declare @lastmonthenddate datetime
   select @lastmonthenddate=eomonth(dateadd(mm,-1,@todaysdate))

   --print @lastmonthenddate

   print '-------------------------------------------------------'  
   print'              INDIAN BANK'   
   print ' list of transaction from ' + @lastmonth_short   +'1st to'+   convert(varchar,@lastmonthenddate,107)   + 'Report'  
   print '-------------------------------------------------------'  
  
  
   --1 : customer info  
     select @custname=name  
  ,@pid=pid  
  ,@brid=brid,  
  @balance=cbal  
  from amaster  
  where acid= @acid  
  --2 print the variable  
  print 'product name  :' + @pid  
  print 'account number:' +cast(@acid as varchar)+ space(18)+  'branch        : ' +@brid  
  print 'customer name : ' + @custname            +space(10) + 'cleared balance: INR ' + cast(@balance as varchar)  
  print '-------------------------------------------------------'  
  print 'SL.NO   DOT      TXN TYPE     CHEQUE NO AMOUNT RUNNINGBALANCE'  
   print '-------------------------------------------------------'  
  
 --3 get previous month transaction done by the given cutomer  
 select row_number() over(order by dot asc) as rno,dot,txntype,chqno,txnamt into #txndata  
 from tmaster where acid= @acid and datediff(mm,dot,getdate())=1  
  
 --4 print the data from temp data  
  --select * from #txndata  
  
 --5 loop  
 declare @x int  
 set @x=1  
  
 declare @cnt int  
   --condition  
   select @cnt=count(*) from #txndata  
   --loop  
   while (@x<=@cnt)  
   begin  
        --get the single row data and store them in variable  
        select @rno=rno,  
  @dot=dot,  
  @txntype=txntype,  
  @chqno=chqno,  
  @txnamt=txnamt  
  from #txndata where rno=@x  
  
  --print the data  
  print cast(@rno as varchar) + space(5) +  
  convert(varchar,@dot,107)+ space(10) +  
  @txntype + space(10) +  
  cast(isnull(@chqno,0) as varchar)+ space(10)+  
  cast(@txnamt as varchar)  
  
  --incr  
  set @x=@x + 1  
 end----loop end  
print '-------------------------------------------------------'  
print 'Total Number of Transactions : ' +cast(@cnt as varchar)
--or
--declare @notxns int
--select @notxns=count(*) from #txndata
--print 'total number of transaction : ' + cast(@notxns as varchar)


declare @CDs int
select @CDs=count(*) from #txndata where txntype='CD' 
print	'number of Cash Deposits    :' + cast(@CDs as varchar)

declare @CWs int
select @CWs=count(*) from #txndata where txntype='CW' 
print	'number of Cash withdrawal    :' + cast(@CWs as varchar)

declare @CQDs int
select @CQDs=count(*) from #txndata where txntype='CQDs' 
print	'number of Cash withdrawal    :' + cast(@CQDS as varchar)
print '---------------------------------------------------------------'
print 'thanks for banking with us. For more help.... Call our Customer Care: 1800 123 3344'
print '---------------------------------------------------------------'
end  


exec usp_previousmonthbankstatement 101



