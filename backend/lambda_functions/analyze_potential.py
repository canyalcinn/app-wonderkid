import json
import boto3
import csv

# AWS SDK (boto3) ile S3 ve DynamoDB'ye erişim
s3_client = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('WonderkidPotansiyel')  # DynamoDB tablo adını doğru şekilde gir

def lambda_handler(event, context):
    # S3'ten CSV dosyasını alma
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    object_key = event['Records'][0]['s3']['object']['key']

    try:
        # S3'ten CSV dosyasını okuma
        response = s3_client.get_object(Bucket=bucket_name, Key=object_key)
        csv_content = response['Body'].read().decode('utf-8') 

        # CSV verilerini işleme
        reader = csv.DictReader(csv_content.splitlines())
        for row in reader:
            # Potansiyel hesaplama
            technical_sum = float(row['Technical'])
            physical_sum = float(row['Physical'])
            mental_sum = float(row['Mental'])
            personal_sum = float(row['Personal'])

            # Hesaplama formülü
            technical_calc = 0.4
            physical_calc = 0.13
            mental_calc = 0.30
            personal_calc = 0.17

            total_points = (technical_sum * technical_calc) + (physical_sum * physical_calc) + (mental_sum * mental_calc) + (personal_sum * personal_calc)
            potential_percentage = (total_points / 160) * 100

            # DynamoDB'ye yazma
            table.put_item(
                Item={
                    'PlayerID': row['PlayerID'],
                    'Potansiyel': potential_percentage
                }
            )

        return {
            'statusCode': 200,
            'body': json.dumps('CSV işlendi ve sonuçlar DynamoDB\'ye yazıldı.')
        }

    except Exception as e:
        print(e)
        return {
            'statusCode': 500,
            'body': json.dumps('Bir hata oluştu.')
        }
