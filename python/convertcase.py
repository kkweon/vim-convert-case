import string
from typing import List

def split_text(text: str) -> List[str]:
    current_word = ""
    ret = []

    for c in text:
        if c.isalnum():
            if c.isupper():
                if current_word:
                    ret.append(current_word)
                current_word = c
            else:
                current_word += c
        elif c in string.punctuation:
            if current_word:
                ret.append(current_word)
                current_word = ""

    if current_word:
        ret.append(current_word)

    return ret

def to_snake_case(text: str) -> str:
    """
    >>> to_snake_case("HelloWorld")
    'hello_world'
    >>> to_snake_case("hello_world")
    'hello_world'
    >>> to_snake_case("helloWorld")
    'hello_world'
    """
    return "_".join(split_text(text)).lower()

def to_camel_case(text: str) -> str:
    """
    >>> to_camel_case('HelloWorld')
    'helloWorld'
    >>> to_camel_case('hello_world')
    'helloWorld'
    >>> to_camel_case('helloWorld')
    'helloWorld'
    """
    ret = to_pascal_case(text)
    return ret[0].lower() + ret[1:]


def to_pascal_case(text:str)->str:
    return ''.join(map(lambda w: w[0].upper() + w[1:].lower(), split_text(text)))

def to_hypen_case(text: str)->str:
    """
    >>> to_hypen_case('Paid59')
    'paid59'
    >>> to_hypen_case('HelloWorld')
    'hello-world'
    """
    return "-".join(split_text(text)).lower()

if __name__ == "__main__":
    import doctest
    doctest.testmod()
