# Exercice 2

1. Zip python file

```
zip lambda_function.py lambda_function_payload.zip
```

2. Init terraform

```
terraform init
```

3. Plan terraform

```
terraform plan
```

4. Apply terraform

```
terraform apply
```

5. Test lambda

```
awslocal lambda invoke --function-name lambda response.json
cat response.json
```