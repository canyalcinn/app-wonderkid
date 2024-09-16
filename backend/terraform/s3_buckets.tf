resource "aws_s3_bucket" "wonderkid_csv_bucket" {
  bucket = "futbol-wonderkid-csv-bucket"
  acl    = "private"
}

# Lambda fonksiyonlarının S3 olaylarıyla tetiklenmesi için izinler
resource "aws_s3_bucket_notification" "lambda_trigger" {
  bucket = aws_s3_bucket.wonderkid_csv_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.analyze_potential.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".csv"
  }
}

# Lambda fonksiyonuna S3 erişim izni ver
resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.analyze_potential.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.wonderkid_csv_bucket.arn
}

resource "aws_s3_bucket_object" "lambda_code" {
  bucket = "futbol-wonderkid-csv-buckete"
  key    = "backend.zip"  # Lambda kodu için zip dosyasının adı
  source = "../backend/backend.zip"  # Lambda kodunun bulunduğu yerel zip dosyası
  acl    = "private"
}

