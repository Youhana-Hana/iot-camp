# Copyright 2022 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# By accessing this sample code, which is considered “AWS Training Content” 
# as defined in the AWS Learner Terms and Conditions,
# https://aws.amazon.com/legal/learner-terms-conditions/, you agree that 
# the AWS Learner Terms and Conditions govern your use of this sample code.

# stop script on error
set -e

# install AWS Device SDK for Python if not already installed
if [ ! -d ./aws-iot-device-sdk-python ]; then
    printf "\nInstalling AWS IoT Device SDK for Python...\n"
    git clone https://github.com/aws/aws-iot-device-sdk-python.git
    pushd aws-iot-device-sdk-python
    sudo python3 setup.py install
    popd
fi

# install jq if not already installed
if ! command -v jq &> /dev/null 
then
    printf "jq could not be found, installing...\n"
    sudo yum install jq
fi

aws iot describe-endpoint > /tmp/iotendpoint.json
iot_endpoint=$(jq -r ".endpointAddress" /tmp/iotendpoint.json)
# run pub/sub sample app using certificates downloaded in package
printf "\nRunning truck sensor sample application...\n"
python3 /home/ec2-user/trucksensor.py -p /home/ec2-user/trucksensordata.csv -e $iot_endpoint -r /home/ec2-user/rootCA.pem -c /greengrass/v2/thingCert.crt -k /greengrass/v2/privKey.key -t data/iot-device-data -d 2 -l True -i core-device-thing-name