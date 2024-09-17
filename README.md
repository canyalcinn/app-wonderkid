Football Wonderkid Scouting & Analysis Application
This project is a web-based application designed to assist football clubs and managers in scouting and analyzing young talents. The app allows users to upload CSV files containing player attributes, which are then automatically processed and analyzed. The results provide potential scores for players based on technical, physical, mental, and personal skills.

Key Features:
CSV Upload: Users can upload CSV files with player data.
Automated Processing: AWS Lambda functions process and analyze player statistics.
DynamoDB Storage: Processed data is stored in DynamoDB for efficient retrieval.
Simple UI: A basic React front-end allows users to select a CSV file, upload it, and view potential calculation results.
CI/CD Pipeline: The project includes a complete CI/CD pipeline using AWS CodePipeline and CodeBuild to automate deployment.
AWS Infrastructure: Managed using Terraform, leveraging services like S3, Lambda, API Gateway, DynamoDB, CodePipeline, and CodeBuild.
