;; title: mdcoin
;; version: 1.0.0
;; summary: MDCoin - A SIP-010 compliant fungible token for the MD ecosystem
;; description: MDCoin is a fungible token that follows the SIP-010 standard,
;;              providing transfer, mint, and burn capabilities with proper
;;              authorization and balance management.

;; traits
(impl-trait .sip-010-trait.sip-010-trait)

;; token definitions
(define-fungible-token mdcoin)

;; constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_INSUFFICIENT_BALANCE (err u101))
(define-constant ERR_INVALID_AMOUNT (err u102))
(define-constant TOKEN_NAME "MDCoin")
(define-constant TOKEN_SYMBOL "MDC")
(define-constant TOKEN_DECIMALS u6)
(define-constant TOKEN_URI u"https://mdcoin.io/token-metadata.json")

;; Initial supply: 1 billion MDC (with 6 decimals)
(define-constant INITIAL_SUPPLY u1000000000000000)

;; data vars
(define-data-var token-uri (optional (string-utf8 256)) (some u"https://mdcoin.io/token-metadata.json"))

;; data maps
;;

;; Initialize token supply
(ft-mint? mdcoin INITIAL_SUPPLY CONTRACT_OWNER)

;; public functions

;; Transfer tokens from sender to recipient
(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (begin
    (asserts! (is-eq tx-sender sender) ERR_UNAUTHORIZED)
    (asserts! (> amount u0) ERR_INVALID_AMOUNT)
    (try! (ft-transfer? mdcoin amount sender recipient))
    (match memo to-print (print to-print) 0x)
    (ok true)
  )
)

;; Mint new tokens (only contract owner)
(define-public (mint (amount uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (asserts! (> amount u0) ERR_INVALID_AMOUNT)
    (ft-mint? mdcoin amount recipient)
  )
)

;; Burn tokens from sender's balance
(define-public (burn (amount uint))
  (begin
    (asserts! (> amount u0) ERR_INVALID_AMOUNT)
    (ft-burn? mdcoin amount tx-sender)
  )
)

;; Set token URI (only contract owner)
(define-public (set-token-uri (new-uri (string-utf8 256)))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (ok (var-set token-uri (some new-uri)))
  )
)

;; read only functions

;; Get token name
(define-read-only (get-name)
  (ok TOKEN_NAME)
)

;; Get token symbol
(define-read-only (get-symbol)
  (ok TOKEN_SYMBOL)
)

;; Get token decimals
(define-read-only (get-decimals)
  (ok TOKEN_DECIMALS)
)

;; Get balance of an account
(define-read-only (get-balance (account principal))
  (ok (ft-get-balance mdcoin account))
)

;; Get total supply
(define-read-only (get-total-supply)
  (ok (ft-get-supply mdcoin))
)

;; Get token URI
(define-read-only (get-token-uri)
  (ok (var-get token-uri))
)

;; Get contract owner
(define-read-only (get-contract-owner)
  (ok CONTRACT_OWNER)
)

;; private functions
;;

