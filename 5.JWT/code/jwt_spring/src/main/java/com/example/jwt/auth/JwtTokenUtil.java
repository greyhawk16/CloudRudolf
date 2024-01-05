package com.example.jwt.auth;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwt;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import lombok.extern.slf4j.Slf4j;
import org.hibernate.validator.internal.util.logging.LoggerFactory;

import java.util.Date;
import java.util.Objects;

@Slf4j
public class JwtTokenUtil {

    // JWT Token 발급
    public static String createToken(String loginId, String key, long expireTimeMs) {
        // Claim = Jwt Token에 들어갈 정보
        // Claim에 loginId를 넣어 줌으로써 나중에 loginId를 꺼낼 수 있음
        Claims claims = Jwts.claims();
        claims.put("loginId", loginId);
        claims.put("isAdmin", "false");

        return Jwts.builder()
                .setClaims(claims)
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + expireTimeMs))
                .signWith(SignatureAlgorithm.HS256, key)
                .compact();
    }

    // Claims에서 loginId 꺼내기
    public static String getLoginId(String token, String secretKey) {
        return extractClaims(token, secretKey).get("loginId").toString();
    }

    // Claims에서 admin 꺼내기
    public static boolean isAdmin(String token, String secretKey) {
        String admin = extractClaims(token, secretKey).get("isAdmin").toString();
        if(Objects.equals(admin, "true"))
            return true;
        else
            return false;
    }

    // 밝급된 Token이 만료 시간이 지났는지 체크
    public static boolean isExpired(String token, String secretKey) {
        Date expiredDate = extractClaims(token, secretKey).getExpiration();
        // Token의 만료 날짜가 지금보다 이전인지 check
        return expiredDate.before(new Date());
    }

    // SecretKey를 사용해 Token Parsing
    private static Claims extractClaims(String token, String secretKey) {
        Jwt jwt = Jwts.parser().setSigningKey(secretKey).parse(token);
        log.info(jwt.toString());
        return (Claims) jwt.getBody();
    }
}