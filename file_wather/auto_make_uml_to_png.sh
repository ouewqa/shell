#!/usr/bin/env bash

#自动将plant uml生成图片
FOLDER="/MyFiles/yunke_svn/云客平台/UML/云客后台"
FILE_4_CHANGES="/tmp/watch"
PLANTUML_JAR="/opt/jar-pkg/plantuml.jar"

function monitor(){
    # cat ${FILE_4_CHANGES}

    while read line; do
        local MAKE_PROCESS_NUMBER=`ps anx | grep -v 'grep' | grep ${PLANTUML_JAR} | wc -l`

        local DIR=`echo ${line} | awk -F ' ' '{print $1}'`
        local FILE=`echo ${line} | awk -F ' ' '{print $2}'`
        local EVENT=`echo ${line} | awk -F ' ' '{print $3}'`

        if [ x${EVENT} == 'xMOVED_FROM' ] && [ ${MAKE_PROCESS_NUMBER} -eq 0 ] ;then
           # echo "makeProcess ${EVENT} ${DIR} ${FILE}"
           makeProcess ${DIR} ${FILE}
        fi

    done < ${FILE_4_CHANGES}

    # 清空文档
    echo '' > ${FILE_4_CHANGES}
}

function makeProcess(){
    local DIR=$1
    local FILE=$2

    mkdir -p ${DIR}/PNG
    #echo "java -jar ${PLANTUML_JAR} ${DIR}/PNG/${FILE}"
    java -jar ${PLANTUML_JAR} "${DIR}${FILE}" -o "${DIR}PNG/"
}

#-m是要持续监视变化。
#-r使用递归形式监视目录。
#-q减少冗余信息，只打印出需要的信息。
#-e指定要监视的事件列表。 create,modify,delete,move
#--timefmt '%d/%m/%y/%H:%M'
#--format '%T %w %f %Xe'
function main() {
    # plant uml 使用先增加临时文件、移到再删除临时文件的更新方式，只需要监控移动的动作即可。
    while inotifywait -q -e move -r ${FOLDER} -o ${FILE_4_CHANGES} --format '%w %f %Xe'; do
        monitor &
    done
};

main