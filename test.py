# # 1. Data Types — Mixing string and integer (TypeError example)
# a = "e";
# b = 10;
# # print(a+b);

# print(type(a));

# # 2. Basic Input & Output — Adding two numbers
# c = int(input())
# d = int(input())
# e=c+d
# print(e)

# # 3. Basic Input & Output — Printing user details
# name = str(input())
# age = int(input())
# address = str(input())

# print("My Name is:",name)
# print("My Age is:",age)
# print("My Address is:",address)

# # 4. Arithmetic Operations — Product, Sum, and Division of three numbers
# a = int(input())
# b = int(input())
# c = int(input())

# d = a*b*c
# print(d)
# e = a+b+c
# print(e)

# f = d/e
# print(f)

# # 5. Score Calculator — Normalizing score out of 10
# name = input()
# score = int(input())
# department = input()

# calculate_score = score/10

# print("My Name is:",name)
# print("My Score is:",str(calculate_score),"/10")
# print("My Department is:",department)

# # 6. If-Else — Pass/Fail based on mark threshold
# mark = int(input("Please enter your mark:"))
# if(mark > 35):
#     print("Pass")
# else:
#     print("Fail")

# # 7. If-Else — Scholarship eligibility based on income
# income = int(input("ENter your income:"))
# if(income > 7000):
#     print("Income",income)
#     print("scholarship is available")
# else:
#     print("Income",income)
#     print("Not Eligible for scholarship")

# # 8. Divisibility Check — Number divisible by 3 or 5
# number = int(input("Enter a number:"))
# three = number % 3
# five = number % 5
# if three == 0:
#     print("entred number:", number)
#     print("the number (", number, ") is divisible by 3")
# elif five == 0:
#     print("entred number:", number)
#     print("the number (", number, ") is divisible by 5")
# else:
#     print("the number (", number, ") is not divisible by 3 or 5")

# # 9. Grading System — Poor / Average / Good based on score
# score = int(input("Enter score:"))
# if score<35:
#     print("Poor Student")
# elif (score>35 and score<75):
#     print("Average Student")
# elif (score>75 and score<100):
#     print("Good Student")
# else:
#     print("Invalid score")

# # 10. Arithmetic Calculator — Add / Sub / Mul / Div based on user operation
# number_a = int(input("Enter first number:"))
# number_b = int(input("Enter second number:"))
# operation = input("Enter the operation which you want add/sub/mul/div:")
# if(operation == "add"):
#     print("Answer :",number_a ,"+",number_b ,"=",number_a+number_b)
# elif(operation == "sub"):
#     print("Answer :",number_a ,"-",number_b ,"=",number_a-number_b)
# elif(operation == "mul"):
#     print("Answer :",number_a ,"*",number_b ,"=",number_a*number_b)
# elif(operation == "div"):
#     print("Answer :",number_a ,"/",number_b ,"=",number_a/number_b)
# else:
#     print("out of the operation",operation)

# # 11. If-Else — Score-based eligibility with nested input
# score = int(input("enter your scorePercentage:"))
# if(score>70):
#     name = input("Enter your name:")
#     department = input("Enter your department:")
#     print(name,"your are eligible")
# else:
#     print("your are not eligible")

# # 12. Loan Eligibility — Based on salary and age (OR condition)
# salary = int(input("Enter your Salary:"))
# age = int(input("Enter your age:"))
# if(salary>=20000 or age<=25):
#     loanAmount = input("Enter your Required loan amount:")
#     print("Success")
# else:
#     print("not eligible")

# # 13. String Iteration
# # Question: Print each character of a string
# for i in "Ganesh":
#     print(i)

# # 14. Multiplication Tables
# # Question: Print multiplication tables of 2 and 3 from 1 to 10
# for i in range(1,11):
#     a = i
#     b = 2
#     print(i,"X",b,"=",a*b)
# print("===================")
# for i in range(1,11):
#     a = i
#     b = 3
#     print(i,"X",b,"=",a*b)

# # 15. Range Printer
# # Question: Print numbers between two user-given values
# a = int(input("Enter a from value:"))
# b = int(input("Enter a to value:"))
# print("I'll Print the number range between the from",a,"to",b)
# for i in range(a+1,b):
#     print(i)

# # 16. Even Numbers
# # Question: Print even numbers from 1 to 10
# for i in range(1,11):
#     a = i%2
#     if(a == 0):
#         print(i)

# # 17. Divisible by 3
# # Question: Print numbers divisible by 3 from 1 to 10
# for i in range(1,11):
#     b = i%3
#     if(b == 0):
#         print(i)

# # 18. Number Classification
# # Question: Classify numbers 1 to 10 as Even / Divisible by 3 / Other
# for i in range(1, 11):
#     a = i % 2
#     b = i % 3
#     if a == 0:
#         print("Even Number", i)
#     elif b == 0:
#         print("Divisible by 3 but odd", i)
#     else:
#         print("other", i)

# # 19. Even Number Counter
# # Question: Print running count of even numbers from 1 to 10
# count = 0
# for i in range(1, 11):
#     if i % 2 == 0:
#         count = count + 1
# print(count)

# # 20. Even & Odd Count
# # Question: Find the number of odd & even numbers between 1 to 10 and print it
# even = 0
# odd = 0
# for i in range(1, 11):
#     if (i % 2 == 0):
#         even = even + 1
#     else:
#         odd = odd + 1
# print(even)
# print(odd)

# # 21. Count Divisible by 3 and 5
# # Question: Count numbers divisible by both 3 and 5 from 1 to 100
# t_count = 0
# for i in range(1,101):
#     if(i % 3 == 0 and i% 5 == 0):
#         t_count = t_count+1
# print(t_count)

# # 22. Sum of Numbers
# # Question: Print sum of numbers from 1 to 5
# number = 0
# for i in range(1,6):
#     number = number+i;
# print(number)

# # 23. Print Sequence
# # Question: Print numbers from 1 to user-given value n
# n = int(input("Enter a value"))
# for i in range(n):
#     print(i+1)

# # 24. List Input
# # Question: Take 10 numbers from user and store in a list
# a=[]
# for i in range(10):
#     b = int(input("Enter num "+ str(i+1)+" " ))
#     a.append(b)
# print(a)

# # 25. List Input (Duplicate)
# # Question: Take 10 numbers from user and store in a list
# a=[]
# for i in range(10):
#     b = int(input("Enter num "+ str(i+1)+" " ))
#     a.append(b)
# print(a)

# # 26. Sum of List
# # Question: Calculate sum of all elements in a list
# total = 0
# for i in a:
#     total = total + i
# print(total)

# # 27. Cube of Numbers
# # Question: Print number and its cube up to user-given value
# a= int(input("Enter the number : "))
# for i in range(1,a):
#     print("Number is :", i ,"and the cube of the",i,"is",i*i*i)

# # 28. Star Pattern
# # Question: Print a right-angled triangle star pattern
# a = '*'
# for i in range(1,5):
#     print()
#     for j in range (1,i+1):
#         print(a,end="")
