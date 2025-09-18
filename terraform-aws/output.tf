output "aws_outputs" {
 value ={
    instance_id = aws_instance.my_instance.id
    instance_public_ip = aws_instance.my_instance.public_ip
    } 
}