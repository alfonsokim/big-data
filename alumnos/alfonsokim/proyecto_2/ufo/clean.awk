#!/usr/bin/env awk

BEGIN { 
    FS = "|" 
} ; { 
    if (NF == 8) {
        print $1
    } else {
        # print $0
    }
}