#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# File definitions
CATALOG_FILE="book_catalog.txt"
MEMBERS_FILE="library_members.txt"
TRANSACTIONS_FILE="book_transactions.txt"

# Initialize data files
setup_system() {
    if [ ! -f "$CATALOG_FILE" ]; then
        cat > "$CATALOG_FILE" << EOF
B001|Harry Potter|J.K. Rowling|Fantasy|Yes|2001|5
B002|The Hobbit|J.R.R. Tolkien|Fantasy|Yes|1937|3
B003|Dune|Frank Herbert|Sci-Fi|Yes|1965|2
B004|The Catcher in the Rye|J.D. Salinger|Fiction|No|1951|1
EOF
    fi
    
    if [ ! -f "$MEMBERS_FILE" ]; then
        cat > "$MEMBERS_FILE" << EOF
M001|Sarah Wilson|sarah.wilson@email.com|Premium|2024-01-15
M002|John Doe|john.doe@email.com|Basic|2024-02-20
M003|Emma Brown|emma.brown@email.com|Premium|2024-03-10
EOF
    fi
    
    if [ ! -f "$TRANSACTIONS_FILE" ]; then
        touch "$TRANSACTIONS_FILE"
    fi
}

# Display system banner
show_banner() {
    clear
    echo -e "${BLUE}╔═════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║               ${WHITE}CUET Library APP                          ${BLUE}║${NC}"
    echo -e "${BLUE}║            ${YELLOW}Library Management Portal                    ${BLUE}║${NC}"
    echo -e "${BLUE}╚═════════════════════════════════════════════════════════╝${NC}"
}

# Main system menu
main_system() {
    while true; do
        show_banner
        echo -e "${CYAN}═══ MAIN PORTAL ═══${NC}"
        echo -e "${YELLOW}1.${NC} Browse Book Catalog"
        echo -e "${YELLOW}2.${NC} Member Services"
        echo -e "${YELLOW}3.${NC} Book Operations"
        echo -e "${YELLOW}4.${NC} Exit System"
        echo -n -e "${WHITE}Select option [1-4]: ${NC}"
        read option
        
        case $option in
            1) catalog_menu ;;
            2) member_menu ;;
            3) operations_menu ;;
            4) echo -e "${GREEN}System shutdown complete!${NC}"; exit 0 ;;
            *) echo -e "${RED}Invalid selection!${NC}"; sleep 1 ;;
        esac
    done
}

# Catalog browsing menu
catalog_menu() {
    while true; do
        show_banner
        echo -e "${CYAN}═══ BOOK CATALOG ═══${NC}"
        echo -e "${YELLOW}1.${NC} View Complete Catalog"
        echo -e "${YELLOW}2.${NC} Search Books"
        echo -e "${YELLOW}3.${NC} Filter by Category"
        echo -e "${YELLOW}4.${NC} Check Availability"
        echo -e "${YELLOW}5.${NC} Return to Main Menu"
        echo -n -e "${WHITE}Select option [1-5]: ${NC}"
        read choice
        
        case $choice in
            1) display_catalog ;;
            2) search_catalog ;;
            3) filter_by_category ;;
            4) check_book_availability ;;
            5) return ;;
            *) echo -e "${RED}Invalid option!${NC}"; sleep 1 ;;
        esac
    done
}

# Member services menu
member_menu() {
    while true; do
        show_banner
        echo -e "${CYAN}═══ MEMBER SERVICES ═══${NC}"
        echo -e "${YELLOW}1.${NC} Register New Member"
        echo -e "${YELLOW}2.${NC} View All Members"
        echo -e "${YELLOW}3.${NC} Update Member Info"
        echo -e "${YELLOW}4.${NC} Member Transaction History"
        echo -e "${YELLOW}5.${NC} Return to Main Menu"
        echo -n -e "${WHITE}Select option [1-5]: ${NC}"
        read choice
        
        case $choice in
            1) register_member ;;
            2) list_members ;;
            3) update_member ;;
            4) member_history ;;
            5) return ;;
            *) echo -e "${RED}Invalid option!${NC}"; sleep 1 ;;
        esac
    done
}

# Book operations menu
operations_menu() {
    while true; do
        show_banner
        echo -e "${CYAN}═══ BOOK OPERATIONS ═══${NC}"
        echo -e "${YELLOW}1.${NC} Add New Book"
        echo -e "${YELLOW}2.${NC} Issue Book to Member"
        echo -e "${YELLOW}3.${NC} Return Book"
        echo -e "${YELLOW}4.${NC} Reserve Book"
        echo -e "${YELLOW}5.${NC} Remove Book from Catalog"
        echo -e "${YELLOW}6.${NC} Popular Books Report"
        echo -e "${YELLOW}7.${NC} Return to Main Menu"
        echo -n -e "${WHITE}Select option [1-7]: ${NC}"
        read choice
        
        case $choice in
            1) add_new_book ;;
            2) issue_book ;;
            3) return_book ;;
            4) reserve_book ;;
            5) remove_book ;;
            6) popular_books ;;
            7) return ;;
            *) echo -e "${RED}Invalid option!${NC}"; sleep 1 ;;
        esac
    done
}

# Display complete catalog
display_catalog() {
    show_banner
    echo -e "${CYAN}═══ COMPLETE BOOK CATALOG ═══${NC}"
    if [ ! -s "$CATALOG_FILE" ]; then
        echo -e "${RED}No books in catalog.${NC}"
    else
        printf "%-6s %-25s %-20s %-12s %-8s %-6s %-5s\n" "Code" "Title" "Author" "Genre" "Status" "Year" "Qty"
        echo "────────────────────────────────────────────────────────────────────────────"
        while IFS='|' read -r code title author genre available year quantity; do
            status_display=$([[ "$available" == "Yes" ]] && echo -e "${GREEN}Available${NC}" || echo -e "${RED}Unavailable${NC}")
            printf "%-6s %-25s %-20s %-12s %-8b %-6s %-5s\n" "$code" "$title" "$author" "$genre" "$status_display" "$year" "$quantity"
        done < "$CATALOG_FILE"
    fi
    echo
    read -p "Press Enter to continue..."
}

# Search books in catalog
search_catalog() {
    show_banner
    echo -e "${CYAN}═══ SEARCH CATALOG ═══${NC}"
    echo "Search Options:"
    echo "1. By Title"
    echo "2. By Author"
    echo "3. By Book Code"
    echo -n "Choose search type [1-3]: "
    read search_type
    echo -n "Enter search term: "
    read term
    
    found=0
    case $search_type in
        1) while IFS='|' read -r code title author genre available year quantity; do
            if echo "$title" | grep -qi "$term"; then
                echo "Code: $code | Title: $title | Author: $author | Available: $available"
                found=1
            fi
           done < "$CATALOG_FILE" ;;
        2) while IFS='|' read -r code title author genre available year quantity; do
            if echo "$author" | grep -qi "$term"; then
                echo "Code: $code | Title: $title | Author: $author | Available: $available"
                found=1
            fi
           done < "$CATALOG_FILE" ;;
        3) if grep -q "^$term|" "$CATALOG_FILE"; then
            result=$(grep "^$term|" "$CATALOG_FILE")
            echo "$result" | while IFS='|' read -r code title author genre available year quantity; do
                echo "Code: $code | Title: $title | Author: $author | Available: $available"
            done
            found=1
           fi ;;
    esac
    
    if [ $found -eq 0 ]; then
        echo -e "${RED}No matching books found.${NC}"
    fi
    read -p "Press Enter to continue..."
}

# Add new book to catalog
add_new_book() {
    show_banner
    echo -e "${CYAN}═══ ADD NEW BOOK ═══${NC}"
    
    # Generate new book code
    if [ -s "$CATALOG_FILE" ]; then
        last_num=$(tail -n 1 "$CATALOG_FILE" | cut -d'|' -f1 | sed 's/B0*//')
        new_num=$((last_num + 1))
        new_code=$(printf "B%03d" $new_num)
    else
        new_code="B001"
    fi
    
    echo "Book Code: $new_code (auto-generated)"
    echo -n "Book Title: "
    read title
    echo -n "Author Name: "
    read author
    echo -n "Genre: "
    read genre
    echo -n "Publication Year: "
    read year
    echo -n "Quantity: "
    read quantity
    
    echo "$new_code|$title|$author|$genre|Yes|$year|$quantity" >> "$CATALOG_FILE"
    echo -e "${GREEN}Book added successfully with code: $new_code${NC}"
    read -p "Press Enter to continue..."
}

# Register new member
register_member() {
    show_banner
    echo -e "${CYAN}═══ MEMBER REGISTRATION ═══${NC}"
    
    # Generate member ID
    if [ -s "$MEMBERS_FILE" ]; then
        last_num=$(tail -n 1 "$MEMBERS_FILE" | cut -d'|' -f1 | sed 's/M0*//')
        new_num=$((last_num + 1))
        new_id=$(printf "M%03d" $new_num)
    else
        new_id="M001"
    fi
    
    echo "Member ID: $new_id (auto-generated)"
    echo -n "Full Name: "
    read name
    echo -n "Email: "
    read email
    echo "Membership Types:"
    echo "1. Basic (2 books max)"
    echo "2. Premium (5 books max)"
    echo -n "Select type [1-2]: "
    read type_choice
    
    case $type_choice in
        1) membership_type="Basic" ;;
        2) membership_type="Premium" ;;
        *) membership_type="Basic" ;;
    esac
    
    join_date=$(date '+%Y-%m-%d')
    echo "$new_id|$name|$email|$membership_type|$join_date" >> "$MEMBERS_FILE"
    echo -e "${GREEN}Member registered successfully with ID: $new_id${NC}"
    read -p "Press Enter to continue..."
}

# Issue book to member
issue_book() {
    show_banner
    echo -e "${CYAN}═══ ISSUE BOOK ═══${NC}"
    echo -n "Enter Member ID: "
    read member_id
    
    if ! grep -q "^$member_id|" "$MEMBERS_FILE"; then
        echo -e "${RED}Member not found!${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    # Check member's current borrowed books
    current_count=$(grep "^$member_id|.*|Issued$" "$TRANSACTIONS_FILE" | wc -l)
    member_type=$(grep "^$member_id|" "$MEMBERS_FILE" | cut -d'|' -f4)
    
    max_books=$([[ "$member_type" == "Premium" ]] && echo 5 || echo 2)
    
    if [ $current_count -ge $max_books ]; then
        echo -e "${RED}Member has reached maximum borrowing limit ($max_books books)${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    echo -n "Enter Book Code: "
    read book_code
    
    if ! grep -q "^$book_code|" "$CATALOG_FILE"; then
        echo -e "${RED}Book not found!${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    available=$(grep "^$book_code|" "$CATALOG_FILE" | cut -d'|' -f5)
    if [ "$available" != "Yes" ]; then
        echo -e "${RED}Book not available for issue!${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    # Update book availability if quantity becomes 0
    quantity=$(grep "^$book_code|" "$CATALOG_FILE" | cut -d'|' -f7)
    new_quantity=$((quantity - 1))
    
    if [ $new_quantity -eq 0 ]; then
        sed -i "/^$book_code|/s/|Yes|/|No|/" "$CATALOG_FILE"
    fi
    
    # Update quantity
    book_info=$(grep "^$book_code|" "$CATALOG_FILE")
    updated_info=$(echo "$book_info" | awk -F'|' -v newqty="$new_quantity" 'BEGIN{OFS="|"}{$7=newqty; print}')
    sed -i "s|^$book_code|.*$|$updated_info|" "$CATALOG_FILE"
    
    # Record transaction
    issue_date=$(date '+%Y-%m-%d')
    due_date=$(date -d '+21 days' '+%Y-%m-%d')
    book_title=$(grep "^$book_code|" "$CATALOG_FILE" | cut -d'|' -f2)
    
    echo "$member_id|$book_code|$book_title|$issue_date|$due_date|Issued" >> "$TRANSACTIONS_FILE"
    echo -e "${GREEN}Book issued successfully!${NC}"
    echo "Due date: $due_date"
    read -p "Press Enter to continue..."
}

# Return book
return_book() {
    show_banner
    echo -e "${CYAN}═══ RETURN BOOK ═══${NC}"
    echo -n "Enter Member ID: "
    read member_id
    
    # Show member's issued books
    issued_books=$(grep "^$member_id|.*|Issued$" "$TRANSACTIONS_FILE")
    if [ -z "$issued_books" ]; then
        echo -e "${RED}No books issued to this member.${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    echo "Currently issued books:"
    echo "$issued_books" | while IFS='|' read -r mid bcode title idate ddate status; do
        echo "Code: $bcode | Title: $title | Due: $ddate"
    done
    
    echo -n "Enter Book Code to return: "
    read book_code
    
    transaction=$(grep "^$member_id|$book_code|.*|Issued$" "$TRANSACTIONS_FILE")
    if [ -z "$transaction" ]; then
        echo -e "${RED}This book is not issued to this member!${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    # Update transaction status
    return_date=$(date '+%Y-%m-%d')
    sed -i "s|^$member_id|$book_code|.*|Issued\$|$member_id|$book_code|$(echo $transaction | cut -d'|' -f3)|$(echo $transaction | cut -d'|' -f4)|$(echo $transaction | cut -d'|' -f5)|Returned-$return_date|" "$TRANSACTIONS_FILE"
    
    # Update book availability
    book_info=$(grep "^$book_code|" "$CATALOG_FILE")
    current_qty=$(echo "$book_info" | cut -d'|' -f7)
    new_qty=$((current_qty + 1))
    
    updated_info=$(echo "$book_info" | awk -F'|' -v newqty="$new_qty" 'BEGIN{OFS="|"}{$7=newqty; print}')
    sed -i "s|^$book_code|.*$|$updated_info|" "$CATALOG_FILE"
    sed -i "/^$book_code|/s/|No|/|Yes|/" "$CATALOG_FILE"
    
    echo -e "${GREEN}Book returned successfully!${NC}"
    read -p "Press Enter to continue..."
}

# List all members
list_members() {
    show_banner
    echo -e "${CYAN}═══ MEMBER LIST ═══${NC}"
    if [ ! -s "$MEMBERS_FILE" ]; then
        echo -e "${RED}No members registered.${NC}"
    else
        printf "%-6s %-20s %-25s %-10s %-12s\n" "ID" "Name" "Email" "Type" "Join Date"
        echo "─────────────────────────────────────────────────────────────────────────"
        while IFS='|' read -r id name email type date; do
            printf "%-6s %-20s %-25s %-10s %-12s\n" "$id" "$name" "$email" "$type" "$date"
        done < "$MEMBERS_FILE"
    fi
    read -p "Press Enter to continue..."
}

# Check book availability
check_book_availability() {
    show_banner
    echo -e "${CYAN}═══ CHECK AVAILABILITY ═══${NC}"
    echo -n "Enter Book Code: "
    read book_code
    
    if ! grep -q "^$book_code|" "$CATALOG_FILE"; then
        echo -e "${RED}Book not found!${NC}"
    else
        book_info=$(grep "^$book_code|" "$CATALOG_FILE")
        title=$(echo "$book_info" | cut -d'|' -f2)
        author=$(echo "$book_info" | cut -d'|' -f3)
        available=$(echo "$book_info" | cut -d'|' -f5)
        quantity=$(echo "$book_info" | cut -d'|' -f7)
        
        echo "Book: $title by $author"
        echo "Status: $([[ "$available" == "Yes" ]] && echo -e "${GREEN}Available${NC}" || echo -e "${RED}Not Available${NC}")"
        echo "Copies available: $quantity"
    fi
    
    read -p "Press Enter to continue..."
}

# Filter books by category with available genres display
filter_by_category() {
    show_banner
    echo -e "${CYAN}═══ FILTER BY GENRE ═══${NC}"
    
    # Show available genres
    echo -e "${YELLOW}Available genres in catalog:${NC}"
    genres=$(cut -d'|' -f4 "$CATALOG_FILE" | sort | uniq)
    echo "$genres" | while read genre; do
        count=$(grep "|$genre|" "$CATALOG_FILE" | wc -l)
        echo "  • $genre ($count books)"
    done
    echo
    
    echo -n "Enter genre to filter: "
    read genre
    
    found=0
    printf "%-6s %-25s %-20s %-8s\n" "Code" "Title" "Author" "Status"
    echo "──────────────────────────────────────────────────────────────"
    while IFS='|' read -r code title author book_genre available year quantity; do
        if echo "$book_genre" | grep -qi "$genre"; then
            status_display=$([[ "$available" == "Yes" ]] && echo "Available" || echo "Unavailable")
            printf "%-6s %-25s %-20s %-8s\n" "$code" "$title" "$author" "$status_display"
            found=1
        fi
    done < "$CATALOG_FILE"
    
    if [ $found -eq 0 ]; then
        echo -e "${RED}No books found in this genre.${NC}"
    fi
    
    read -p "Press Enter to continue..."
}

# Reserve book functionality
reserve_book() {
    show_banner
    echo -e "${CYAN}═══ RESERVE BOOK ═══${NC}"
    echo -n "Enter Member ID: "
    read member_id
    
    if ! grep -q "^$member_id|" "$MEMBERS_FILE"; then
        echo -e "${RED}Member not found!${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    echo -n "Enter Book Code: "
    read book_code
    
    if ! grep -q "^$book_code|" "$CATALOG_FILE"; then
        echo -e "${RED}Book not found!${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    available=$(grep "^$book_code|" "$CATALOG_FILE" | cut -d'|' -f5)
    if [ "$available" == "Yes" ]; then
        echo -e "${YELLOW}Book is currently available. You can issue it directly.${NC}"
    else
        reserve_date=$(date '+%Y-%m-%d')
        book_title=$(grep "^$book_code|" "$CATALOG_FILE" | cut -d'|' -f2)
        echo "$member_id|$book_code|$book_title|$reserve_date||Reserved" >> "$TRANSACTIONS_FILE"
        echo -e "${GREEN}Book reserved successfully! You will be notified when available.${NC}"
    fi
    
    read -p "Press Enter to continue..."
}

# Popular books report
popular_books() {
    show_banner
    echo -e "${CYAN}═══ POPULAR BOOKS REPORT ═══${NC}"
    
    if [ ! -s "$TRANSACTIONS_FILE" ]; then
        echo -e "${RED}No transaction history available.${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    echo -e "${YELLOW}Most Issued Books:${NC}"
    echo
    
    # Count book issues and sort by popularity
    temp_file=$(mktemp)
    grep "|Issued$\||Returned-" "$TRANSACTIONS_FILE" | cut -d'|' -f2,3 | sort | uniq -c | sort -nr > "$temp_file"
    
    if [ -s "$temp_file" ]; then
        printf "%-5s %-6s %-30s %-15s\n" "Rank" "Times" "Book Title" "Book Code"
        echo "──────────────────────────────────────────────────────────────────"
        rank=1
        while read count code title; do
            printf "%-5s %-6s %-30s %-15s\n" "#$rank" "$count" "$title" "$code"
            rank=$((rank + 1))
            if [ $rank -gt 10 ]; then break; fi  # Show top 10 only
        done < "$temp_file"
    else
        echo -e "${RED}No book issue records found.${NC}"
    fi
    
    rm -f "$temp_file"
    read -p "Press Enter to continue..."
}

# Remove book from catalog
remove_book() {
    show_banner
    echo -e "${CYAN}═══ REMOVE BOOK ═══${NC}"
    echo -n "Enter Book Code to remove: "
    read book_code
    
    if ! grep -q "^$book_code|" "$CATALOG_FILE"; then
        echo -e "${RED}Book not found!${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    # Check if book is currently issued
    if grep -q "|$book_code|.*|Issued$" "$TRANSACTIONS_FILE"; then
        echo -e "${RED}Cannot remove book! It is currently issued to a member.${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    book_title=$(grep "^$book_code|" "$CATALOG_FILE" | cut -d'|' -f2)
    echo -n "Are you sure you want to remove '$book_title'? (y/N): "
    read confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        sed -i "/^$book_code|/d" "$CATALOG_FILE"
        echo -e "${GREEN}Book removed successfully from catalog.${NC}"
    else
        echo -e "${YELLOW}Operation cancelled.${NC}"
    fi
    
    read -p "Press Enter to continue..."
}

# Update member information
update_member() {
    show_banner
    echo -e "${CYAN}═══ UPDATE MEMBER INFO ═══${NC}"
    echo -n "Enter Member ID: "
    read member_id
    
    if ! grep -q "^$member_id|" "$MEMBERS_FILE"; then
        echo -e "${RED}Member not found!${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    current_info=$(grep "^$member_id|" "$MEMBERS_FILE")
    current_name=$(echo "$current_info" | cut -d'|' -f2)
    current_email=$(echo "$current_info" | cut -d'|' -f3)
    current_type=$(echo "$current_info" | cut -d'|' -f4)
    join_date=$(echo "$current_info" | cut -d'|' -f5)
    
    echo "Current Information:"
    echo "Name: $current_name"
    echo "Email: $current_email"
    echo "Type: $current_type"
    echo
    
    echo -n "New Name (press Enter to keep current): "
    read new_name
    [ -z "$new_name" ] && new_name="$current_name"
    
    echo -n "New Email (press Enter to keep current): "
    read new_email
    [ -z "$new_email" ] && new_email="$current_email"
    
    echo "Membership Type:"
    echo "1. Basic"
    echo "2. Premium"
    echo "3. Keep current ($current_type)"
    echo -n "Select [1-3]: "
    read type_choice
    
    case $type_choice in
        1) new_type="Basic" ;;
        2) new_type="Premium" ;;
        *) new_type="$current_type" ;;
    esac
    
    # Update member info
    sed -i "s|^$member_id|.*$|$member_id|$new_name|$new_email|$new_type|$join_date|" "$MEMBERS_FILE"
    echo -e "${GREEN}Member information updated successfully!${NC}"
    read -p "Press Enter to continue..."
}

# Member transaction history
member_history() {
    show_banner
    echo -e "${CYAN}═══ MEMBER TRANSACTION HISTORY ═══${NC}"
    echo -n "Enter Member ID: "
    read member_id
    
    if ! grep -q "^$member_id|" "$MEMBERS_FILE"; then
        echo -e "${RED}Member not found!${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    member_name=$(grep "^$member_id|" "$MEMBERS_FILE" | cut -d'|' -f2)
    echo "Transaction history for: $member_name ($member_id)"
    echo
    
    transactions=$(grep "^$member_id|" "$TRANSACTIONS_FILE")
    if [ -z "$transactions" ]; then
        echo -e "${RED}No transaction history found.${NC}"
    else
        printf "%-6s %-25s %-12s %-12s %-15s\n" "Code" "Book Title" "Issue Date" "Due Date" "Status"
        echo "────────────────────────────────────────────────────────────────────────────"
        echo "$transactions" | while IFS='|' read -r mid bcode title idate ddate status; do
            printf "%-6s %-25s %-12s %-12s %-15s\n" "$bcode" "$title" "$idate" "$ddate" "$status"
        done
    fi
    
    read -p "Press Enter to continue..."
}

# Initialize and start system
setup_system
main_system