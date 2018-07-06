set-asg-desired-to-zero() {
  EC2_INSTANCE_ID="`wget -q -O - http://instance-data/latest/meta-data/instance-id`"
  EC2_ASG_NAME="`aws ec2 describe-instances --filter="Name=instance-id,Values=$EC2_INSTANCE_ID" \
    | python -c 'import sys, json; print [tag for tag in json.load(sys.stdin)["Reservations"][0]["Instances"][0]["Tags"] if tag["Key"] == "aws:autoscaling:groupName"][0]["Value"]'`"
  aws autoscaling set-desired-capacity --auto-scaling-group-name $EC2_ASG_NAME --desired-capacity 0
}
