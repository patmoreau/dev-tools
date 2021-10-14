ip=$(minikube ip)
profile=$(minikube profile)

dnsConfig=$(cat << EOF
domain test
nameserver $ip
search_order 1
timeout 5
)

echo "$dnsConfig" > "/etc/resolver/minikube-$profile-test"

cat "/etc/resolver/minikube-$profile-test"