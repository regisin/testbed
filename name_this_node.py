def main():
    # Sets static IP address of wlan0 in template file
    import os
    import argparse
    
    parser = argparse.ArgumentParser()
    parser.add_argument('--node-id', type=int, help='the node id to rename the IP/hostname/etc [1-254]')
    args = parser.parse_args()
    node_id = args.node_id
    node_number = node_id
    
    while not 1 <= node_number <= 254: node_number = int(raw_input("What is the number of this node? [1-254]: "))
    ipath = os.path.realpath(os.path.join(os.sep,'etc','network','interfaces'))
    opath = os.path.realpath(os.path.join(os.sep,'etc','network','interfaces.new'))
    with open(ipath,'r') as finput:
        with open(opath,'w') as foutput:
            for line in finput:
                foutput.write(line.replace('{node_number}',str(node_number)))
    os.remove(ipath)
    os.rename(opath, ipath)
    
    # Edit hostname: raspberrypiX, where X is the node number
    hpath = os.path.realpath(os.path.join(os.sep,'etc','hostname'))
    node_hostname = "unr-cse-ss-rp-"+"%02d" % (node_number,)
    with open(hpath,'w') as f:
        f.write(node_hostname)
    
    # Update /etc/hosts
    ipath = os.path.realpath(os.path.join(os.sep,'etc','hosts'))
    opath = os.path.realpath(os.path.join(os.sep,'etc','hosts.new'))
    with open(ipath,'r') as finput:
        with open(opath,'w') as foutput:
            for line in finput:
                foutput.write(line.replace('raspberrypi',str(node_hostname)))
    os.remove(ipath)
    os.rename(opath, ipath)
    
if __name__ == "__main__":
    main()
