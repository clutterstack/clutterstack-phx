## Subresource Integrity

If you are loading Highlight.js via CDN you may wish to use [Subresource Integrity](https://developer.mozilla.org/en-US/docs/Web/Security/Subresource_Integrity) to guarantee that you are using a legimitate build of the library.

To do this you simply need to add the `integrity` attribute for each JavaScript file you download via CDN. These digests are used by the browser to confirm the files downloaded have not been modified.

```html
<script
  src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/11.10.0/highlight.min.js"
  integrity="sha384-pGqTJHE/m20W4oDrfxTVzOutpMhjK3uP/0lReY0Jq/KInpuJSXUnk4WAYbciCLqT"></script>
<!-- including any other grammars you might need to load -->
<script
  src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/11.10.0/languages/go.min.js"
  integrity="sha384-Mtb4EH3R9NMDME1sPQALOYR8KGqwrXAtmc6XGxDd0XaXB23irPKsuET0JjZt5utI"></script>
```

The full list of digests for every file can be found below.

### Digests

```
sha384-zSqDrr2HUSwHCgmRiMQUtbc4a9qpKFct6B3w54ZZNGTsBuHy0PUufQmLF4rLwY6X /es/languages/applescript.js
sha384-2kZ9vXS4PfcoGlwJ5gNbv5QnUY15tcWNHxJePONFXmRi7pgWs7WAOaJlfA1JRFN6 /es/languages/applescript.min.js
sha384-no5/zgQGupzPFGWV8VpJzfQau5/GI2v5b7I45l6nKc8gMOxzBHfgyxNdjQEnmW94 /es/languages/bash.js
sha384-u2nRnIxVxHkjnpxFScw/XgxNVuLz4dXXiT56xbp+Kk2b8AuStNgggHNpM9HO569A /es/languages/bash.min.js
sha384-+9dzNYaLHp3OPspFCOJGrEwfiOV3yqeD/atUDYVt9zKUJ8IW2QxffCT2LfmGfwfW /es/languages/css.js
sha384-G44u1/pUATC8754FIKYqkCxCl9AQYnspnFxzuR3RB1YVnTvqOEofqvZNQMUWcY/1 /es/languages/css.min.js
sha384-aZt7VNjEA1w4GeGPtZOPocoO/e6oIc9bMjNlN0GMXRkOoTMaEM2FCq4B6GkHANht /es/languages/diff.js
sha384-3J9ZKxCAysZ+DowS+TRZQFLDNVJwRq0pxq9t/JYsuFRmBSwgvJrbRDH4Av46yJft /es/languages/diff.min.js
sha384-dpaRAfrfqLJ/m4qzPviZ8UztzpU27eoBSH+8GjP1nkccMBZ6x9EnnhvlNYMDz0P2 /es/languages/django.js
sha384-xmWxMjSXleWbbNXqoQdpI8OkRJnRmiuJ8cmkovyFJSZxyjycv8DA4XuENvWPDLDk /es/languages/django.min.js
sha384-rHmCT89JQB59w2aVe2yFkMa+yxnKwA74LUHu4FN92sbr1FFDmYqv2QAwNBG47rkr /es/languages/dns.js
sha384-FyQp/yTYnwHmm+XuKfVGWxFNrGlgQ5KeEfWuNLOkj9AVIMPZPAx74qjwIQz2V5rt /es/languages/dns.min.js
sha384-conFwWhJOaJ8yLyZJUeX6IlE3YGpdoxazLFVV//QB5E+ASXMVyFnQE1V6SfgMzEq /es/languages/dockerfile.js
sha384-Dw9HMdbM7eZULiZ40cTZJ0NU88GUU5VQ22H+PVZ0IzxPGdnPPqKdsg4Uk3D2wbCB /es/languages/dockerfile.min.js
sha384-b/W5D/qsSQTbKCPuKtIscnizUYtiwuhSIhPbqytRsu3sZ8hc5+KPeWbItFn9Ewi+ /es/languages/elixir.js
sha384-Uo+KLVze+/A9YCgMDJ4XtbATny5jt/ABQshKJVHut77YNUuS/zPVYAGKeLFdthjP /es/languages/elixir.min.js
sha384-+kBglEeWcSwdonwqsD/TpIjXwMn5FIeukuWgfAWv+QC1NDsZGeANBqgeir0aOENB /es/languages/erb.js
sha384-jKl1B10yci152fjeFFWOiIxAnyuqjj+GrabCB2d6Dq0jHIYs0kqsCF31KINUC9i5 /es/languages/erb.min.js
sha384-UprkYUPD60WsGmpla3Npim2r1f0q1YUvuLyap7OkTyFvaGCxjt/RcBDXFxGuFiWA /es/languages/erlang.js
sha384-ffehxKri+ZLFXqRZcDwKHI+OuCy3tWvJDjxmY7kTJNnF4EB//blTQga2gnOuh3UT /es/languages/erlang.min.js
sha384-Ks9Ra36zIOLujhBc23kvCUZzy1IBMsAK/rBZ2FrVZEQf6uzoxzu5+bWOhHOAEs8C /es/languages/erlang-repl.js
sha384-9HUVbJs7C6TSuS3lg1gYv9UONx7830CSmNM1C4hxswmRia0EkeP3w0VbufumsO+B /es/languages/erlang-repl.min.js
sha384-U0cmcZmeG0JVcA3HKR6r7Sio0x8FtcXR7eviBCcgniMwCc+DMiV6IQPm7bFn6BPh /es/languages/go.js
sha384-5Mzx2XTmXU2XQ0AiQg/4HA9SbBDrPySZgpsOfSfflGdzC4bIpCjWSxIP62fOIFkO /es/languages/go.min.js
sha384-DmHzDhCE3ltNMxzvFexjBF+ku3PcoAMY7WFOXlWIZnV+vEiPek+T5FVXBuYELEAg /es/languages/graphql.js
sha384-y8dkUR8w2ApytztUtIg+27fJuiL5sH1oq9uRGEcpH9zcoYPU/ZFvroB77kwDE7d6 /es/languages/graphql.min.js
sha384-yIW2CKaxiozMCGVe7a2RX90kdUjP0h2gALuNlfKbojKpQn1OmMQLGO7BOqhncFO6 /es/languages/http.js
sha384-j+2AgmE+4SlZjmviwPvbGypcb9BQNHQj043l9Bb3F2fnlusdNxxA5/INHsOrSE6g /es/languages/http.min.js
sha384-oQpcUGMBf+VDTHOLQ1uhPp1FgNBo0OZc9gbXGuVFwAogHlkh/Iw6cvKKgcgCQkmV /es/languages/javascript.js
sha384-3T8DJ91yCa1//uY9h8Bo4QLrgEtbz4ILN2x9kSM4QWX9/1kKu6UXC3RAbVQV85UQ /es/languages/javascript.min.js
sha384-R87hRh4kF8+iz2sB6FvLrfR0XZBohjFXeJKIXld1Eji2UVi+M2+OIgJKma/9Ko6u /es/languages/json.js
sha384-QFDPNpqtrgZCuAr70TZJFM4VCY+xNnyGKwJw2EsWIBJOVcWAns9PHcLzecyDVv+x /es/languages/json.min.js
sha384-JkFMmKMbHcXjdfHauRnREGG6i73GyMisdqNivBm4Z9m2Oc82YIu5jQtIjLa508e8 /es/languages/markdown.js
sha384-65/lNNIY+ayhHTtFznjnyZ5w2NDdZIpSEcqjss/p4ex5JamZ46FdYwDDf6IBLCmE /es/languages/markdown.min.js
sha384-WuxmFqZ8YXr3xyK1Salq5t1q46F/VyzVGx48M2ZJPhbodzQ9L8kfnP/0seU78NsC /es/languages/nginx.js
sha384-XOua+gbAwDawIeMkI2pkXOZH9Xxl9/XLoGuPJD5Bs3WS4bMn207o20s+aQtpsqqE /es/languages/nginx.min.js
sha384-BxojDi6ePBYN3unEc6aUEpUtUyx0Eq0i/UZPISuI2YQy6eAD5HzD0dtBC53uZ6R1 /es/languages/php.js
sha384-C28kAnknmyKQUME+2sa0tyQkFMN1S/aUSB1gQ+PKUf0+ewgxNh8CwAmd+C0UUaZ7 /es/languages/php.min.js
sha384-dkR9Qv3ZGmcTGGFP26gmcHC9DBgRYE0XLGxF3mBXlBZaBrscW0vIiVN7oTyQmrbe /es/languages/plaintext.js
sha384-AkqanemYxn6S3BQnW2++1+xqywaq2bJfFlfiAkPNd7Yv5t9YsS8tFzVVopyOa747 /es/languages/plaintext.min.js
sha384-e+d8RFZbtc5Pmt3xfX9uuElm63v5qOj7T5hAkkFbnYc1wEk7wCLlzOsm66MCf5Uk /es/languages/python.js
sha384-CPHh+9FxkWF3OtMZdTj5oQN1Qti0p4/5XBABz/JdgssOKHmfAOFz6Gu4tsG6MQiH /es/languages/python.min.js
sha384-Blm/RpTi15HpdenfAja/zwDDJ6bBmIoAsFgHcNpw4u+DqKFZEpB67DIa2A1NXtZf /es/languages/ruby.js
sha384-INdPgGNAH51T3uWXoaYVa0ag70hxlbvjTlhyLicF3SuuG0BVuycs/GrFGi7gt/8a /es/languages/ruby.min.js
sha384-LZ+YGF0Xve9sHzC9G37Kc14gDC6lfDpny2hggVJVfHb+OsTEXgMGLmAWUJzi4YRC /es/languages/rust.js
sha384-/ktfWRgwL+kZAZeeXDl9mwkD/3atjwjkzLCCoSHtME7MzP87wMhUmNUZ83AoqYx2 /es/languages/rust.min.js
sha384-VYwyP5ddOUunx1AGpbtE38OKY2PbjW9kk6X6622tvqprRJk6W8/tgMvI7MqaOZZw /es/languages/shell.js
sha384-gRgqaIgHrAR1qlo866rkV1AUahqopv0dnpFFLAC4X3jYTDagRCTxQBTMFGV1+x1U /es/languages/shell.min.js
sha384-ZX3mm6sjLYWMBTMUJYzvQXYHNWVJkD+t1ppx4BysyVs6cVhvYFVuwMlVCeAwtwm9 /es/languages/sql.js
sha384-DloKeCkj/pTPHeqWu3keGoEPpZJGm44yQjSmSfpWasykAMUobM0hcYFFPsg1PE6K /es/languages/sql.min.js
sha384-BcyijKQAe0oJGoEBf0y/+dTJjKiy4bIAVdjreJw+MiOkPgCEjM/2FY2+W7K6tcEZ /es/languages/typescript.js
sha384-Mfjt0R07QBpLXhGWeCetLw7s2mTQSoXmcyYnfsSNq4V4YG3FwayBjxod9MxjSB1x /es/languages/typescript.min.js
sha384-Tdx2DY9ZTHx3KhVXYqOVKx3q1zOboDGlTTv8sgMlER8y4WETtqL+C4VQ7B4A0OGq /es/languages/xml.js
sha384-n9ZezaAVj8pK1BIFZQxmC1BM9yGuBNRgvsOxHMHPCXzqYd1gSYIu9KjgGEm8K57w /es/languages/xml.min.js
sha384-40MP6/ECSjYaTAIf+/ibE2FPeFPQ53WbASndXxMOcXiQtgLbGXUStZVuPSngp7OD /es/languages/yaml.js
sha384-vXmhozexi2dHQBoniIEbWI5ZqDxyVfUs96BUGpqjWL1aberSp9pyxbvK8WCNASGB /es/languages/yaml.min.js
sha384-yT2h9v4yE2Auvceykn+LhHfjtMdOZRZZ78+POjlKH3ELxv31LG55iDcPPpl1B9D1 /languages/applescript.js
sha384-/ZGnKBtFlWz3dap5TeG4EtewOydrfxdAP22FQI2zXLM9BtAVmutZf6VLqcnNKwoy /languages/applescript.min.js
sha384-4SbTAv3AX2fuPCpSv6HW3p07YgA7hFfcwG2zJHtYv0ATIt1juD3IXj2NSYwTeIpm /languages/bash.js
sha384-83HvQQdGTWqnRLmgm19NjCb1+/awKJGytUX9sm3HJb2ddZ9Fs1Bst2bZogFjt9rr /languages/bash.min.js
sha384-h6xPJgkyvp13tIs697wZHjCH20tW1aJOrvnAKiZZiATSWZp0lyLB4bAdsEhWUSze /languages/css.js
sha384-+MO3D3y/aZzZq7QMAAA5KiuAcqBZivJHFmVUXfwdBoLxEXeGTeQGsNMll4fpnegg /languages/css.min.js
sha384-ptbaKMqucgUUAhyaQfodHtSDpTA0AAoyGZZqos59ECIdi1qKRnUZcLOxMkZaxkul /languages/diff.js
sha384-IZ99gU0P2i3O8itOlz4exVdl6lGFAgj7zq4hgyoe29bt1KyJykBSCxdH8ubn3DSk /languages/diff.min.js
sha384-gfyiMmAn2+1KPBU6zgf5/GuxwAS1MG2sXO2QNIa1b8gWqS+ZAEGASFZUv2DTTr0I /languages/django.js
sha384-E8a05vTFeTlJrGsYy6uvHSN7YyYtYVDfuTB0NYKryrTqkKAh0Kljndtou/5x9KxE /languages/django.min.js
sha384-GEtDae05TD65Rudc09ryy9h0sXTp18D4g24uImkYj4cC4pmv9QSL9gpFFduB6mRv /languages/dns.js
sha384-KEzcnJSlyQjvNpDwNeh6LUBpvcvNSFDj5NMNxUiH/1XzSiutw7KXKxsqF+LJm6+P /languages/dns.min.js
sha384-KgZWfCUcAWOSNTSNOBUrbGToPbSNE30TSimcL9oKDQ35EApOQoCYU4o2ayix5Ohe /languages/dockerfile.js
sha384-jg4vR4ePpACdBVLAe+31BrI3MW4sfv1AS62HlXRXmQWk2q98yJqKR5VxHzuABw8X /languages/dockerfile.min.js
sha384-qtlgQhMe3dPictT/p8u+Re+71kMSr/Zgoe0GwOS80c0tbv1ZnDlQ9E8RQMoPvk/W /languages/elixir.js
sha384-1yAJ5qBg8K80+przprGQnQPGeFIb3tKmAVjHnSSEZiq4HKjh3cNy/nwzJ7l2nFK+ /languages/elixir.min.js
sha384-X3X5mf91CrWWGZ9b3+VLi7Qm5aWxDv2NQDRoVls8Mp5weWmncrpxblLBZ4dNp0QH /languages/erb.js
sha384-gEX03lFlUpoA8rfkmZ2UaKi2820eK1l0gtckxIGjq6Czr2uCyyEfekMrSoFwej+C /languages/erb.min.js
sha384-SlKWu3SvV7MLl/uYjSGXVo0n5bflYsgkvmH8lmKx1XmwA3jKehvoWmuCHcXsMbjj /languages/erlang.js
sha384-0CP4DzMXyug19cwGTs3ONRRpUBBFTa4O5Hv9YjyJY10yvQOl5W+x5LOifval6ZBt /languages/erlang.min.js
sha384-5p6je/gKFM1nHFcEZz+30/mQBcCs9uhZWG4CnGvaucHJ5oCsM9zaN+mFGpyMvzM4 /languages/erlang-repl.js
sha384-/FY+XRWmaEh7r6TTcq3KEOxwB6sp4MEUUh0Ls2PNyfch1P2kpYlIm6HF9INVd7MS /languages/erlang-repl.min.js
sha384-B9Y0sXbhPrwdlpzfeFn4NkyJrhYEUFUCTMrEVRu+d2/3aJ/4ZOjFPJRZFnJdaQJm /languages/go.js
sha384-Mtb4EH3R9NMDME1sPQALOYR8KGqwrXAtmc6XGxDd0XaXB23irPKsuET0JjZt5utI /languages/go.min.js
sha384-y4jAHac6QZpx9l3FE/Q9CbTHzEhF8S7+9Hm8AY4PfpSCmQWpPCdW1rBh63nXebrT /languages/graphql.js
sha384-2vKrGN0+i0vPRkMvpEZkOgi35/Vyn5pGG9Oi+baBPODVLjCrGyhQpwDG+BBEEeA3 /languages/graphql.min.js
sha384-5njNAV6cayF+v1sc70/t3BTkztvcp8TZ61d65U8YUQuXJ45PIrhcgNfccRMd9JsI /languages/http.js
sha384-ubRntct0s40ZDtDRLkxA3/xYX51o5yC2U8SKlky8dhIRsjSnvZiUKLhz0gNTewno /languages/http.min.js
sha384-p/utwvqrRVOLlz0BjJ0BCGCb2liTDipfz47/QmGXz9hoPIjCKYEgmYUC30VmGgZy /languages/javascript.js
sha384-L/XmDiyusXomLRGcRmcBpPlboRFjpQNV747OJvg+sEOpgGYvUsNwcC4JLNQ2dI6O /languages/javascript.min.js
sha384-psmmPlbfEWGyvRapexDqkVTgNz7Y1xvlGdLNWQSafI4GFQYFDXPZxVXH1laU4n6l /languages/json.js
sha384-Bb6DhE3tUpBROwypL78TbhRUs9QbCt2GxcxVSYglt2l3MefrYkm4CfwjfWhRfQaX /languages/json.min.js
sha384-TVvUXbmPgdS59xZSFUeyNQ1vUkeCbBpuMj3qlzdEwdQhoO5F/WNdI94UEw8g7Enp /languages/markdown.js
sha384-sFh+6oaRBb6kdaMLf8x7qeH7NTvm2u1Ta6PtI0S8hoA+bP7UtHCyKFzaI1JBXwhT /languages/markdown.min.js
sha384-GqxuhQ5X9X3c8nNswtucj7gX9fAuYCtI73NbFLXAYNqX39+zocekxv7SOK6oVGhi /languages/nginx.js
sha384-TG8jUbt29ktiHxVaCkA6FLnJkL/PYG3zQwEYexdbr+Z6mMkFf+c0ONpHyuIY4vvG /languages/nginx.min.js
sha384-swGDgtGOmzrsbFAaQRjzvGs0hhe0N86mfHIuisr3W9AT0hiheGyRORSGrbMDGOw5 /languages/php.js
sha384-Xd0AQIkWCEjBL8BNMtDMGVqFXkf445J6PNUJdXbh334ckjeSa90wtSUjXySuz+rt /languages/php.min.js
sha384-v4qiQbdZu8obdLOFoHrZxA44mmxnjZUelyHe7A6RuqmckxO5weYQVrN8Dx2UpAR1 /languages/plaintext.js
sha384-hE+znpd5xggEBW6IccZoCI0mgFHAfLVuqT/7aW8RakaQ4UJnI058SfIX3lhdGxtE /languages/plaintext.min.js
sha384-WNah6F2QDUbmrNCi0fSEyKJbSb01S1ijnoiwbDnegW7dm2Cz/H1CiH1HhWlUvj01 /languages/python.js
sha384-YDj7s2Wf0QEwarV3OB8lvoNJJCH032vOLMDo2HDrYiEpQ+QmKN+e++x3hElX5S+w /languages/python.min.js
sha384-nHCt5/kJd7LUp6BbVLNuUH0zziFVRS2Qqj9whqRpVpgzybI61OZlKQRPv4evHrJO /languages/ruby.js
sha384-LOFdRHZ5u+oZg5Wh8DpkiJQR/w8egcUhJJoo95XVQ846DEwuRxGUujx+tQKyqXme /languages/ruby.min.js
sha384-rCXn7K5j/lD2PrSex2XCqyLKap2Ibnsls0uQCx4ZaezI1FJ5RYvoWcsAl/v8SKlE /languages/rust.js
sha384-VTNxHMz2AmpHxzSm8SvRI0As5+wID2j2XJBFtWTic2iEK8WbXgR1fymVQS9S2DvY /languages/rust.min.js
sha384-KYOeDvyFo8fJObDV1L1aoPnfs6XG68LL6j3INM7McXyRYtBZF7DdUsNjK25dtxKo /languages/shell.js
sha384-olAuUjfRvTi/iEH4RXRpaq/G1iJGizn7OefkyJLQYuqNhh1xAV5dnUrkH/LlPd9j /languages/shell.min.js
sha384-w/OmtgUvmlKWaVatpcvuEQxP7bkJzI5gLeeQkuXjApJNiQvNmXFL2PBM5RWgKqDr /languages/sql.js
sha384-2uzCjI3OPwJce6i2hphsYs1qqTqRrDnfPXbfjZggPWy2/Lgl8gzV9Hyl0jhhoWy4 /languages/sql.min.js
sha384-4q0Mj1AHSvVdgi6nXDGdkiHZQcme/PcCE+MvwCvnAIZSjhJfk3UpjJU2nn2eImWz /languages/typescript.js
sha384-rfwxAwuWzb2XdSU7HN3IhrSyCq96Nj4p1ZYPCNAGbqtnPsaWl8d5eSypxPbW6alT /languages/typescript.min.js
sha384-QAL2h4IMgQaJUJjUy0dSWdAut7o/A272ai8qOsJ8SSm9KMxkdLgH7oGfLGft/EJ0 /languages/xml.js
sha384-CN3No+n1UZXCFYyl+ge5yAPGTNGuH23BdIsFJxntDmEYL94AmoZlNBHGSdjVSjKG /languages/xml.min.js
sha384-3KIoWvJ5JGRH35WAkzreEebY8sug+ZWeaOPS2r1KIfznEU9TtPFpxX6sIgtaiA9G /languages/yaml.js
sha384-bMkvdnz+wPu1ro0fqO3BaDWztc7RzSvw05MQFP6bhJKDcwpkrFYTfTFI9ndkP11l /languages/yaml.min.js
sha384-SH3CuFuz/Q6WhVlMKePaEEBNi2hOSvqdk+KTffZMr+vsau1fs8S+XbVMvMAVsaJy /highlight.js
sha384-1lIyUsuqjkuj90zoKGTARZd+z7bzNo9z84NkY8OV7RO7eTxtGiywcjo9v3I1186O /highlight.min.js
```

