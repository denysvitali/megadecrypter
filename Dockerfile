FROM crystallang/crystal

COPY . /app

WORKDIR /app

RUN crystal build --release src/megadecrypter.cr

CMD megadecrypter