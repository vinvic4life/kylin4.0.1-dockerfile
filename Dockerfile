#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Docker image for apache kylin, based on the Hadoop image
FROM hadoop3.2-all-in-one-for-kylin4

ENV RELATED_SPARK_VERSION spark2
ENV KYLIN_VERSION 4.0.1
ENV KYLIN_HOME /home/admin/apache-kylin-4.0.1-bin-spark2
ENV MDX_HOME /home/admin/mdx-kylin-4.0.1-beta

# Download Kylin
RUN wget https://media.githubusercontent.com/media/vinvic4life/mycloudkite/master/apache-kylin-4.0.1-bin-spark2.zip \
    && unzip /home/admin/apache-kylin-4.0.1-bin-spark2.zip \
    && rm -f /home/admin/apache-kylin-4.0.1-bin-spark2.zip
RUN rm -f $KYLIN_HOME/conf/kylin.properties
# See KYLIN-5071
RUN sed -i "s/\"kylin.engine.build-base-cuboid-enabled\":\ \"false\"/\"kylin.engine.build-base-cuboid-enabled\":\ \"true\"/g" $KYLIN_HOME/sample_cube/template/cube_desc/kylin_sales_cube.json
COPY conf/kylin/* $KYLIN_HOME/conf/
RUN mkdir -p $KYLIN_HOME/bin/hadoop3_jars/cdh6
COPY hive-exec-1.21.2.3.1.0.0-78.jar $KYLIN_HOME/bin/hadoop3_jars/cdh6
COPY stax2-api-3.1.4.jar $KYLIN_HOME/bin/hadoop3_jars/cdh6
COPY commons-configuration-1.10.jar $KYLIN_HOME/lib/
RUN sed -i "s/hbase/java/g" $KYLIN_HOME/bin/set-java-home.sh

COPY ./entrypoint.sh /home/admin/entrypoint.sh
RUN chmod u+x /home/admin/entrypoint.sh

ENTRYPOINT ["/home/admin/entrypoint.sh"]
