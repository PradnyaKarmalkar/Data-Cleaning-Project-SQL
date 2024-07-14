select * from layoffs;

create table layoffs_stagging
like layoffs;


Insert layoffs_stagging
select * from layoffs;

select * from layoffs_stagging;

      -- Removing Duplicates
      
select * , 
row_number() over (partition by company,location,industry,total_laid_off,percentage_laid_off,
'date',stage,country,funds_raised_millions)
 as row_num 
 from  layoffs_stagging;
 
with duplicate_cte as
(select * , 
row_number() over (partition by company,location,industry,total_laid_off,percentage_laid_off,
'date',stage,country,funds_raised_millions)
 as row_num 
 from  layoffs_stagging)
 select * from duplicate_cte where row_num>1;
 
 select * from layoffs_stagging where company='Casper';
 
 
 
 with duplicate_cte as
(
select * , 
row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,
'date',stage,country,funds_raised_millions)
 as row_num 
 from  layoffs_stagging
 )
 delete 
 from duplicate_cte
 where row_num >1;
 
 CREATE TABLE `layoffs_stagging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from layoffs_stagging2;

Insert into layoffs_stagging2
select * , 
row_number() over (partition by company,location,industry,total_laid_off,percentage_laid_off,
'date',stage,country,funds_raised_millions)
 as row_num 
 from  layoffs_stagging;
 
delete 
from layoffs_stagging2 
where row_num>1;

select * from layoffs_stagging2 ;

                         -- Standardizing Data
 
 select company ,TRIM(company)
 from layoffs_stagging2;

update layoffs_stagging2
set company=TRIM(company);

select *
 from layoffs_stagging2
 where industry like'Crypto%'  ;
 
 update layoffs_stagging2 set industry='Crypto' where industry like 'Crypto%';
 
 
select *
 from layoffs_stagging2
 where country like'United States%'  order by 1;
 
 select distinct country , trim(TRAILING '.' FROM country)
 from layoffs_stagging2
 order by 1;
 
 update layoffs_stagging2 
 set country=trim(TRAILING '.' FROM country) where country like 'United States%';
 
 
 select `date` ,
 str_to_date(`date`,'%m/%d/%Y')
 from layoffs_stagging2;
 
 update layoffs_stagging2 
 set `date`=str_to_date(`date`,'%m/%d/%Y');

 ALTER TABLE layoffs_stagging2
 MODIFY COLUMN `date` DATE;
 
                   -- Dealing with Null Values
                   
                   
 select * from layoffs_stagging2
 where total_laid_off is null 
 and percentage_laid_off is null;
 
 update layoffs_stagging2 
 set industry =null
 where industry='';
 
select * from layoffs_stagging2
where industry is null or  industry='';

select t1.industry , t2.industry
from layoffs_stagging2 t1
join layoffs_stagging2 t2 on t1.company=t2.company
where t1.industry is null 
and t2.industry is not null;

update layoffs_stagging2 t1
join layoffs_stagging2 t2
    on t1.company=t2.company 
set t1.industry=t2.industry
where t1.industry is null 
and t2.industry is not null;

select * from  layoffs_stagging2 ;

          -- Remove Any Column

alter table layoffs_stagging2 
drop column row_num;

select * from layoffs_stagging2
where total_laid_off is null and percentage_laid_off is null;

 delete from layoffs_stagging2
where total_laid_off is null and percentage_laid_off is null;
 
 
 
 
 
 
 
 
 
