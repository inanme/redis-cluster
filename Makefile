.PHONY: start 

define REDIS_CONF
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
endef

export REDIS_CONF
create:
	for s in {7001..7009}; do (echo $${s} ; mkdir -p $${s};); done;
	for port in */; do (cd $$port; echo "$$REDIS_CONF\nport $$port" > redis.conf;); done;

start:
	for s in */; do (echo $${s} ; cd $${s} ; pwd; redis-server ./redis.conf & ); done;

cluster:
	echo yes | redis-cli --cluster create \
	127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 \
	127.0.0.1:7004 127.0.0.1:7005 127.0.0.1:7006 \
	127.0.0.1:7007 127.0.0.1:7008 127.0.0.1:7009 \
	--cluster-replicas 2

delete:
	pkill redis-server
	rm -rf */

client:
	redis-cli -c -p 7001

commit:
	git add .
	git commit -amupdate
	git pull --rebase
	git push origin master