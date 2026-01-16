with loan_payment as (
select 
    loan_id,
    max(payment_date) as last_payment_date,
    sum(amount_paid) as total_paid
from 'data_sources/loan_repayment_payments.csv'
group by loan_id
),
fully_paid_loans as (
    select 
        l.loan_id,
        l.loan_amount,
        l.due_date,
        case when lp.total_paid = l.loan_amount then 1 else 0 end as is_fully_paid,
        case when lp.last_payment_date <= l.due_date then 1 else 0 end as paid_on_time
        from 'data_sources/loan_repayment_loans.csv' l
    left join loan_payment lp
    on l.loan_id = lp.loan_id
)
select * from fully_paid_loans
-- select * from 'data_sources/loan_repayment_loans.csv'